'use strict'
angular.module 'app.TA'

.config ($state-provider) !->
  $state-provider.state 'app.TA.review-list', {
    url: '/review-list?hid'
    resolve:
      users: (api-resolver) -> api-resolver.resolve 'users@get'
      homeworks: (api-resolver) -> api-resolver.resolve 'homeworks@get'
    views:
      'content@app':
        template-url: 'app/main/TA/review-list/review-list.html'
        controller-as : 'vm'
        controller: ($scope, $filter, $state-params, $state, $location, Authentication, Interaction, homeworks, DTOptionsBuilder, users)!->

          @homework = _.find homeworks.data, {'id': 1}
          # console.log @homework

          @test = [1,2]
          @user = Authentication.get-user!
          @greeting = @user.fullname
          @location = "评审列表"
          @theme = Interaction.get-bg-by-month 2

          @student-users = _.filter users.user, 'class'


          @_classes = _.groupBy @student-users, 'class'

          # console.log @_classes
          @classes = []
          for id of @_classes
            groups = _.groupBy @_classes[id], 'group'
            @classes.push {id: id, groups: groups, members: @_classes[id]}

          console.log @classes

          @top-index = 1


  }
