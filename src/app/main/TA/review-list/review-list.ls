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
        controller: ($scope, $filter, $state-params, $state, reviewListService, Authentication, homeworks, users)!->

          service = reviewListService
          auth = Authentication
          @go-to-anchor = service.go-to-anchor

          @homework = _.find homeworks.data, {'id': 1}

          @user = auth.get-user!

          @student-users = service.get-student-users-by-class users.user

          @classes = service.get-classes @student-users

          @homeworks = homeworks.data

          @selected = []
          i = @classes.length
          while i > 0
            @selected[i] = i.to-string!
            i--

          @goToDetail = (hid, sid)!->
            $state.go 'app.TA.review-detail', {
              hid: hid
              sid: sid
            }
  }


