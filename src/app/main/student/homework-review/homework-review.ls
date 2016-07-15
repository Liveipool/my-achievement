'use strict'

angular.module 'app.student'

.config ($state-provider) !->
  $state-provider.state 'app.student.homework-review', {
    url: '/homework-review/:id'
    # resolve:
    #   homeworks: ($resource) ->
    #     $resource('app/data/homework/homeworks.json').get!.$promise
    #       .then (result)->
    #         homeworks = result.data
    #         Promise.resolve homeworks
    data:
      role: 'student'

    views:
      'content@app':
        template-url: 'app/main/student/homework-review/homework-review.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, $state, Interaction, $state-params, review-manager)!->

          console.log "here is homework review"
          @user = Authentication.get-user!
          @location = "作业互评"
          @theme = Interaction.get-bg-by-month 2
          @greeting  = @user.fullname;

          @homework-id = $state-params.id
          @date-time = new Date()

          # functions of the buttons
          @submit = (review)->
            if 0 < review.score and review.score <= 100 and review.comment != ""
              review-manager.add-review review
              review.comment = review.temp-comment
              review.score   = review.temp-score
              review.editing = false
            else
              alert "error"

          @edit = (review) ->
            review.editing = true

          @update = (review) ->
            review-manager.update-review review
            review.comment = review.temp-comment
            review.score   = review.temp-score
            review.editing = false

          @cancle = (review) ->
            review-manager.cancle-update-review review
            review.temp-comment = review.comment
            review.temp-score   = review.score
            review.editing      = false


          # get the data:

          # gr means reviews in "group review" and ms means in "my score"
          @reviews-gr = []
          @reviews-ms = []

          # when thenable, vm is @, be careful
          vm = @

          # first get all reviews
          review-manager.get-all-reviews!
          # then filtering by homework id
          .then (all-reviews) ->
            review-manager.reviews-filter-by-id all-reviews, vm.homework-id
          # then filtering by @user.username, being careful about the @ and vm
          .then (reviews-id) ->
            review-manager.reviews-filter-by-username reviews-id, vm.user.username
          # then we get what we want
          .then (reviews-id-username) ->
            vm.reviews-gr = reviews-id-username.gr
            vm.reviews-ms = reviews-id-username.ms

            # test submit, no score and no comment at the beginning
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

            console.log reviews-id-username

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
