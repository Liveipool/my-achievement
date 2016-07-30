'use strict'

angular.module 'app.student'

.config ($state-provider) !->
  $state-provider.state 'app.student.homework-review', {
    url: '/homework-review/:id'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data
            Promise.resolve homeworks

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
        controller: ($scope, $state, Interaction, Authentication, $state-params, homework-review-service, myscore-reviews, group-reviews)!->
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

          vm.reviews-ms
          @date-time = new Date()

          # functions of the buttons
          @submit = (review)->
            status = homework-review-service.validator review
            if status.state
              review.comment = review.temp-comment
              review.score   = review.temp-score
              homework-review-service.add-review review
              review.editing = false
              review.t-score = "hs"
              review.error = {}
            else
              review.error = status.error
            console.log review.error

          @edit = (review) ->
            review.editing = true

          @update = (review) ->
            status = homework-review-service.validator review
            if status.state
              review.comment = review.temp-comment
              review.score   = review.temp-score
              homework-review-service.update-review review
              review.editing = false
              review.error = {}
            else
              review.error = status.error
            console.log review.error

          @cancle = (review) ->
            homework-review-service.cancle-update-review review
            review.temp-comment = review.comment
            review.temp-score   = review.score
            review.editing      = false
            review.error = {}


          test-submit-review = {
            "reviewee": {
            "username": "94971446",
            "fullname": "郝肥如"
            },
            "reviewer": {
            "username": "45479458",
            "fullname": "林放高",
            "role": "student"
            },
            "homework_id": 1,
            "class": 1,
            "group": 1
          }
          vm.reviews-gr.push test-submit-review


          for r in vm.reviews-ms
            r.bg = 'image-div-' + (1 + parse-int 12 * Math.random!)

          for r in vm.reviews-gr

            # every can be edited at the beginning
            r.editing = true

            # buffer for editing score and comment
            r.temp-score   = r.score
            r.temp-comment = r.comment

            # homework image
            r.bg = 'image-div-' + (1 + parse-int 12 * Math.random!)

            if r.score
              # if have score means already submit before so can not be edited at the beginning
              r.editing = false

              # hs means have score and ns means no score
              # t-score means the translation of score, then put the right class on review
              r.t-score = 'hs'
            else
              r.t-score = 'ns'

  }
