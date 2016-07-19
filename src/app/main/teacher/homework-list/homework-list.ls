'use strict'

angular.module 'app.teacher'

.controller 'teacherTimer', ($scope, $interval, timerService) !->
  $scope.status-table = 
    'future':'未开始'
    'present': '进行中'
    'finish': '已结束'
  $scope.status-helper = (classes, status) ->
    for c in classes
      if c.status == status
        return true
    false
  timer = $interval (!->
    $scope.remain = timerService.calculateRemain $scope.class.startTime, $scope.class.endTime, $scope.class.status
    if $scope.class.status != $scope.remain.status
      $scope.class.status = $scope.remain.status
      $scope.class.t-status = $scope.status-table[$scope.remain.status]
      if $scope.status-helper $scope.homework.classes, 'present'
        $scope.homework.status = 'present'
        $scope.homework.t-status = '进行中'
      else
        if $scope.status-helper $scope.homework.classes, 'future'
          $scope.homework.status = 'future'
          $scope.homework.t-status = '未开始'
        else
          $scope.homework.status = 'finish'
          $scope.homework.t-status = '已结束'
    if $scope.remain.status == "finish" then $interval.cancel(timer)), 1000




.config ($state-provider) !->
  $state-provider.state 'app.teacher.homework-list', {
    url: '/homework-list'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data
            Promise.resolve homeworks
    views:
      'content@app':
        template-url: 'app/main/teacher/homework-list/homework-list.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks, $state, Interaction)!->

          @user = Authentication.get-user!
          @location = "所有作业"
          @theme = Interaction.get-bg-by-month 2
          @greeting  = @user.fullname;
          if @user.role is 'teacher'
            @greeting = @greeting + '老师'


          @edit-homework = (hid) ->
            $state.go 'app.teacher.edit-homework', {id : hid}
          @review-homework = (hid) ->
            $state.go 'app.teacher.review-homework', {id : hid}


          @status-helper = (classes, status) ->
            for c in classes
              if c.status == status
                return true
            false
          @calculate-status = (hs) !->
            for h in hs
              #矫正假数据中，status随着时间推移而产生错误的影响
              for c in h.classes
                nowTime = new Date!
                startTime = new Date c.startTime
                endTime = new Date c.endTime
                if nowTime < startTime 
                  c.status = 'future'
                else if nowTime < endTime
                  c.status = 'present'
                else 
                  c.status = 'finish'
                  

              if @status-helper h.classes, 'present'
                h.status = 'present'
                h.t-status = '进行中'
              else
                if @status-helper h.classes, 'future'
                  h.status = 'future'
                  h.t-status = '未开始'
                else
                  h.status = 'finish'
                  h.t-status = '已结束'
            for h in hs
              h.bg = 'image-div-' + (1 + parse-int 12 * Math.random!)
              h.description = 'https://' + h.description if not /http/.test h.description
              # avoid missing the 'http'
              for c in h.classes
                c.t-status = '进行中' if c.status == 'present'
                c.t-status = '未开始' if c.status == 'future'
                c.t-status = '已结束' if c.status == 'finish'

          @homeworks = homeworks
          @calculate-status @homeworks

  }
