'use strict'

angular.module 'app.student'

.config ($state-provider) !->
  $state-provider.state 'app.student.homework-review', {
    url: '/homework-review/:id'
    resolve:
      homework: (api-resolver, $state-params) ->
        api-resolver.resolve 'lb_homework_get_one@get', {id: $state-params.id}

      myscore-reviews: (homework-review-service, Authentication, $state-params) ->
        user = Authentication.get-user!
        homework_id = $state-params.id
        homework-review-service.get-myscore-reviews user, homework_id

      group-reviews: (homework-review-service, Authentication, $state-params) ->
        user = Authentication.get-user!
        homework_id = $state-params.id
        homework-review-service.get-group-reviews user, homework_id


    data:
      role: 'student'

    views:
      'content@app':
        template-url: 'app/main/student/homework-review/homework-review.html'
        controller-as : 'vm'
        controller: ($scope, $state, Interaction, Authentication, $state-params, homework-review-service, myscore-reviews, group-reviews, homework)!->
          console.log group-reviews
          vm = @

          # get the data:

          # gr means reviews in "group review" and ms means in "my score"
          @reviews-gr = []
          @reviews-ms = []
          @reviews-gr = group-reviews
          @reviews-ms = myscore-reviews

          @user = Authentication.get-user!
          @homework-id = $state-params.id
          @date-time = homework.classes[@user.class-1].endTime
          




          for r in vm.reviews-ms
            r.bg = 'image-div-' + (1 + parse-int 12 * Math.random!)



  }
