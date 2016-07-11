'use strict'

angular.module 'app.student'

.config ($state-provider) !->
  $state-provider.state 'app.student.homework.review', {
    url: '/homework/review'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data.homeworks
            Promise.resolve homeworks
    views:
      'content@app':
        template-url: 'app/main/student/homework/review/review.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks)!->
          console.log "欢迎回来!"
  }