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


          # the button state:
          # init:   no score -> submit -> review-manager.add-review!
          #       have score -> edit then init change to editing
          # editing:  update -> review-manager.update-review!
          #           cancle -> review-manager.cancle-update-review!
          #           both then editing change to init

          @submit = (review-need-to-add)->
            review-manager.add-review review-need-to-add

          @edit = (review-need-to-edit) ->
            review-need-to-edit.edit = true

          @update = (review-need-to-edit) ->
            review-manager.update-review review-need-to-edit
            review-need-to-edit.edit = false

          @cancle = (review-need-to-edit) ->
            review-manager.cancle-update-review review-need-to-edit
            review-need-to-edit.edit = false


          # get the data:

          # gr means group review and ms means my score
          @reviews-gr = []
          @reviews-ms = []

          # when thenable, vm is @
          vm = @

          # first get all reviews
          review-manager.get-all-reviews!

          # next filtering by homework id
          .then (all-reviews) ->
            review-manager.reviews-filter-by-id all-reviews, vm.homework-id

          # next filtering by @user.username, being careful about the @ and vm
          .then (reviews-id) ->
            review-manager.reviews-filter-by-username reviews-id, vm.user.username

          # then we get what we want
          .then (reviews-id-username) ->
            vm.reviews-gr = reviews-id-username.gr
            vm.reviews-ms = reviews-id-username.ms
            console.log reviews-id-username


  }
