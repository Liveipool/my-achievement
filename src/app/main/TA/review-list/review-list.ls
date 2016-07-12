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
        controller: ($scope, $filter, $state-params, $state, $location, $anchor-scroll, Authentication, Interaction, homeworks, DTOptionsBuilder, users)!->

          @go-to-anchor = (c_id, g_id) ->
            # body...
            new-hash = "class" + c_id + "-group" + g_id
            if $location.hash! !== new-hash
              $location.hash new-hash
            else
              $anchor-scroll!
          @test = (c_id,g_id) ->
            console.log c_id + g_id



          # $ "vertical-container-1" .scroll-unique!
          @homework = _.find homeworks.data, {'id': 1}

          @user = Authentication.get-user!

          @greeting = @user.fullname

          @location = "评审列表"

          @theme = Interaction.get-bg-by-month 2

          @student-users = _.filter users.user, 'class'


          @_classes = _.groupBy @student-users, 'class'

          # console.log @_classes
          @classes = []
          for id of @_classes
            groups = []
            _groups = _.groupBy @_classes[id], 'group'
            for _id of _groups
              groups.push {id: _id, members: _groups[_id]}
            @classes.push {id: id, groups: groups, members: @_classes[id]}

          console.log @classes

          @selected = []
          i = @classes.length
          while i > 0
            @selected[i] = i.to-string!
            i--

          console.log @selected

          @top-index = 1


  }
