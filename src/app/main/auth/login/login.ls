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
          login: -> Authentication.login @form .then (user)~>
            console.log user
            if user
              @invalid-user = false
              $state.go 'app.patients'
            else
              @invalid-user = true
  }

.run ($root-scope, $state, Authentication)!->
  $root-scope.$on '$stateChangeStart', (event, to-state, to-params, from-state)!->

    console.log "state change start"
    # 同步不同标签页之间的状态
    if !Authentication.is-exists!

      console.log 'user isnt exists'
      Authentication.get-cookie-user! .then (user)!~>
        if user?
          $state.go 'app.patients'
          event.prevent-default!
        else if !user and to-state.name isnt 'app.login'
          $state.go 'app.login'
          event.prevent-default!

 # TODO
 # 每次页面跳转都会运行下面代码，所以该方案不可行
  # $root-scope.$on '$stateChangeSuccess', (event, to-state, to-params, from-state)!->

  #   console.log 'state change success'

    # #退出登录
    # if Authentication.is-exists!

    #   from-state-path = from-state.name
    #   ancestor-paths = from-state-path.split '.'

    #   if ancestor-paths and ancestor-paths[0] is 'app' and from-state-path isnt 'app.login'
    #     Authentication.logout!


  $root-scope.$on '$logout', (event)!->
    authService.current-user = $root-scope.current-user = null
    $state.go 'app.login'
