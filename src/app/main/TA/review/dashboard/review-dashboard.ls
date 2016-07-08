'use strict'

angular.module 'app.TA'

.config ($state-provider) !->
  $state-provider.state 'app.TA.review.dashboard', {
    url: '/homework/TA-review-list'
    resolve:
      data: (api-resolver) -> api-resolver.resolve('classes@get')
    views:
      'content@app':
        template-url: 'app/main/TA/review/dashboard/review-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, $filter, Authentication, data, DTOptionsBuilder)!->
          console.log "review-dashboard"
          #console.log(data.data);
          @user = Authentication.get-user!
          @classes = data.data
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
