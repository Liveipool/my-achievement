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
          @reviews = []

          vm = @
          # when thenable, vm is @

          review-manager.get-all-reviews!
          .then (all-reviews) ->
            # first filtering by homework id
            review-manager.reviews-filter-by-id all-reviews, vm.homework-id
          .then (reviews-id) ->
            # next filtering by @user.username, being careful about the @ and vm
            review-manager.reviews-filter-by-username reviews-id, vm.user.username
          .then (reviews-id-username) ->
            vm.reviews = reviews-id-username
            console.log vm.reviews


  }
