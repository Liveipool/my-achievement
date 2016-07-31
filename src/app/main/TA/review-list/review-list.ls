'use strict'
angular.module 'app.TA'

.config ($state-provider) !->
  $state-provider.state 'app.TA.review-list', {
    url: '/review-list?hid'
    resolve:
      users: (api-resolver) -> api-resolver.resolve 'users@get'
      homeworks: (api-resolver) -> api-resolver.resolve 'homeworks@get'
    views:
      'content@app':
        template-url: 'app/main/TA/review-list/review-list.html'
        controller-as : 'vm'
        controller: ($scope, $filter, $state-params, $state, homeworkReviewService , reviewListService, Authentication, homeworks, users)!->

          # pie的数据以及UI定义
          @datacolumns = [
            {"id": "s0", "type": "pie", "name": "0-59"},
            {"id": "s1", "type": "pie", "name": "60-69"},
            {"id": "s2", "type": "pie", "name": "70-79"},
            {"id": "s3", "type": "pie", "name": "80-89"},
            {"id": "s4", "type": "pie", "name": "90-100"},
          ]
          @datapoints = []

          homework-id = parse-int $state-params.hid

          list-service = reviewListService
          homework-service = homeworkReviewService
          auth = Authentication

          @go-to-anchor = list-service.go-to-anchor

          @homework = _.find homeworks.data, {'id': homework-id }
          @user = auth.get-user!

          # 根据班级和组别分开用户
          @student-users = list-service.get-student-users-by-class users.user
          @classes = list-service.get-classes @student-users

          # 获取该作业的所有老师和TA的review
          thats = @
          homework-service.get-all-reviews!.then (reviews)!->
            homework-service.reviews-filter-by-id reviews, homework-id .then (homework-reviews)!->
              ta-reviews = homework-service.reviews-filter-by-reviewer-role homework-reviews, "ta"
              teacher-reviews = homework-service.reviews-filter-by-reviewer-role homework-reviews, "teacher"
              list-service.add-ta-score-to-students ta-reviews, thats.student-users
              list-service.add-teacher-score-to-students teacher-reviews, thats.student-users
              
              # 计算分值范围
              for i from 0 to thats.classes.length - 1 by 1
                thats.classes[i].datapoints = []
                for j from 0 to thats.classes[i].members.length - 1 by 1
                  if !thats.classes[i].members[j].teacher-score then continue
                  s = Math.ceil ((thats.classes[i].members[j].teacher-score - 59) / 10)
                  if s <= 0 then s = 0
                  else if s >= 5 then s = 4
                  thats.classes[i]["s" + s] ||= 0
                  thats.classes[i]["s" + s]++
                thats.add-pie-datapoint thats.classes[i], thats.classes[i].datapoints
              if thats.classes.length > 0 then thats.pie-change.call thats, thats.classes[0].id

          # 为每个班级定义Pie数据
          @add-pie-datapoint = (oneclass, data)!->
            for i from 0 to 4 by 1
              key = "s" + i
              if !oneclass[key]
                oneclass[key] = 0
              newone = {}
              newone[key] = oneclass[key]
              data.push newone

          # 点击Tab根据班级id切换Pie数据
          @pie-change = (ev)!->
            if typeof ev !~= 'string'
              ev = ev.target.get-attribute "pie-id"
            for i from 0 to @classes.length - 1 by 1
              if @classes[i].id ~= ev
                @datapoints = @classes[i].datapoints
                break

          @selected = []
          i = @classes.length
          while i > 0
            @selected[i] = i.to-string!
            i--
  }


