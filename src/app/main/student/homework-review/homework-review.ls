'use strict'

angular.module 'app.student'

.config ($state-provider) !->
  $state-provider.state 'app.student.homework-review', {
    url: '/homework-review'
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
        controller: ($scope, Authentication, $state, Interaction)!->
          console.log \here
          @user = Authentication.get-user!
          @location = "作业互评"
          @theme = Interaction.get-bg-by-month 2
          @greeting  = @user.fullname;

  }
