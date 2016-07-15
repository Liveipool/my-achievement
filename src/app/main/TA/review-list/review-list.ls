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
        controller: ($scope, $filter, $state-params, $state, reviewService, Authentication, Interaction, homeworks, users)!->

          service = reviewService
          auth = Authentication
          @go-to-anchor = service.go-to-anchor

          @homework = _.find homeworks.data, {'id': 1}

          @user = auth.get-user!

          @greeting = @user.fullname

          @location = "评审列表"

          @theme = Interaction.get-bg-by-month 2

          @student-users = service.get-student-users-by-class users.user

          @classes = service.get-classes @student-users

          @selected = []
          i = @classes.length
          while i > 0
            @selected[i] = i.to-string!
            i--
  }

.factory 'reviewService', ($location, $anchor-scroll)->
  service =
    go-to-anchor: (class-id, group-id) ->
      new-hash = "class" + class-id + "-group" + group-id
      if $location.hash! !== new-hash
        $location.hash new-hash
      else
        $anchor-scroll!

    get-student-users-by-class: (users) ->
      _.filter users, 'class'

    get-classes: (student-users) ->
      _classes = _.groupBy student-users, 'class'
      # console.log _classes
      classes = []
      for id of _classes
        groups = []
        _groups = _.groupBy _classes[id], 'group'
        for _id of _groups
          groups.push {id: _id, members: _groups[_id]}
        classes.push {id: id, groups: groups, members: _classes[id]}
      return classes

    # get-selects : (classes) ->
    #   selects = []
    #   for id in classes
    #     _class = classes[id]
    #     i = parse-int _class.id
    #     selects[i] = 1
    #   se



