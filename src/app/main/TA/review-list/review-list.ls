'use strict'

angular.module 'app.TA'

.config ($state-provider) !->
  $state-provider.state 'app.TA.review-list', {
    url: '/review-list?hid'
    resolve:
      data1: (api-resolver) -> api-resolver.resolve 'classes@get'
      data2: (api-resolver) -> api-resolver.resolve 'homeworks@get'
    views:
      'content@app':
        template-url: 'app/main/TA/review-list/review-list.html'
        controller-as : 'vm'
        controller: ($scope, $filter, $state-params, $state, $location, Authentication, data1, data2, DTOptionsBuilder)!->
          console.log "review-dashboard"
          #console.log(data1.data);
          console.log $location.search()
          @homeworkId = parseInt($location.search().hid || '1');
          console.log(@homeworkId);
          for homework in data2.data
            if (homework.id == @homeworkId)
              @homeworkTitle = homework.title
              break
          @user = Authentication.get-user!
          @classes = data1.data
          @dtInstances = []
          @searchWords = []
          @highScore = []
          @lowScore = []
          @averageScore = []
          for x in @classes
            @dtInstances.push {}
            @searchWords.push ''
          @scoreCounter = [];

          for aClass, i in @classes
            @scoreCounter.push [0, 0, 0, 0]
            t1 = 0
            t2 = 100
            t3 = 0
            avgCounter = 0
            for student in aClass
              if student.TAscore
                t1 = t1 >? student.TAscore
                t2 = t2 <? student.TAscore
                t3 += student.TAscore
                ++avgCounter
                if student.TAscore >= 90
                  ++@scoreCounter[i][0]
                else if student.TAscore >= 80
                  ++@scoreCounter[i][1]
                else if student.TAscore >= 70
                  ++@scoreCounter[i][2]
                else if student.TAscore >= 60
                  ++@scoreCounter[i][3]
            @highScore.push t1
            @lowScore.push t2
            @averageScore.push( (t3 / avgCounter) .toFixed 2)

          @dtOptions = DTOptionsBuilder.newOptions! .withDisplayLength 10 .withPaginationType 'simple' .withDOM 'tip'

          @search = (index)!~>
            @dtInstances[index] .DataTable .columns 0 .search @searchWords[index] .draw!



  }
