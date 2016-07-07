'use strict'
angular.module 'app.auth.login', []

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider)->
  $translate-partial-loader-provider.add-part 'app/main/auth/login'

  $state-provider.state 'app.login', {
    url               : '/login'
    body-class        : 'login'
    views             :
      'main@'         :
        template-url  : 'app/core/layouts/content-only.html'
        controller    : 'MainController as vm'

      'content@app.login'  :
        template-url            : 'app/main/auth/login/login.html'
        controller-as           : 'vm'
        controller              : ($scope, $root-scope, Authentication, $state)->
          $scope.$on '$stateChangeSuccess', (event, to-state, to-params, from-state)!->

            console.log '退出登录!'
            # #退出登录
            if Authentication.is-exists!

              from-state-path = from-state.name
              ancestor-paths = from-state-path.split '.'

              if ancestor-paths and ancestor-paths[0] is 'app' and from-state-path isnt 'app.login'
                Authentication.logout!

          login: -> Authentication.login @form .then (user)~>
            console.log user
            if user
              @invalid-user = false
              $state.go 'app.student.homework.dashboard'
            else
              @invalid-user = true
  }

