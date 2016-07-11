'use strict'

angular.module 'fuse'

.controller 'MainController', ($scope, $root-scope, ms-navigation-service, $state, Authentication)!->
  'ngInject'
  # Remove the splash screen
  $scope.$on '$viewContentAnimationEnded', (event)-> $root-scope.$broadcast 'msSplashScreen::remove' if event.target-scope.$id is $scope.$id

  nav = ms-navigation-service
  nav.save-item 'user',  {title : "用户"   , group: true,   weight   : 2,  class: 'user' }
  if user = Authentication.get-user!
    nav.save-item 'user.profile',  {title : " #{user.fullname}，您好！"   , image: user.avatar,   state : 'app.profile',    weight   : 2,  class: 'profile' }
    nav.save-item 'user.logout',  {title : '退出'   , icon: 'icon-logout',   state : 'app.login',   weight   : 2,  class: 'login'  } if user?
    nav.delete-item 'user.login'

  else
    nav.delete-item 'user.profile'
    nav.delete-item 'user.logout'
    nav.save-item 'user.login',  {title : '登录'   , icon: 'icon-login',   state : 'app.login',    weight   : 2,  class: 'logout' } if !user?

  state-change-listener-stop = $root-scope.$on '$stateChangeStart', (event, to-state)!->

  nav.set-folded true

  $root-scope.$on 'destroy', !-> state-change-listener-stop!
