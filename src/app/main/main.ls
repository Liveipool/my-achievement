'use strict'



angular.module 'fuse'

.config navigations = ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider)!->
  'ngInject'
  nav = ms-navigation-service-provider




  # --------- 菜单 ----------- #

  nav.save-item 'homework', {title: "作业", group: true, weight: 1, class: 'homework'}

  nav.save-item 'homework.dashboard', {title: "作业详情", weight: 1, icon: 'icon-book-open', state: 'app.student.homework.dashboard'}

<<<<<<< HEAD
  nav.save-item 'TA', {title: "TA评审", group: true, weight: 1, class: 'TA'}

  nav.save-item 'TA.dashboard', {title: "作业列表", weight: 1, icon: 'icon-book-open', state: 'app.TA.review.dashboard'}
=======
  nav.save-item 'homework.review', {title: "查看排名", weight: 1, icon: 'icon-pen', state: 'app.student.homework.review'}

>>>>>>> zihao/dev
  nav.save-item 'user',  {title : "用户"   , group: true,   weight   : 2,  class: 'user' }

.controller 'MainController', ($scope, $root-scope, ms-navigation-service, $state, Authentication)!->
  'ngInject'
  # Remove the splash screen
  $scope.$on '$viewContentAnimationEnded', (event)-> $root-scope.$broadcast 'msSplashScreen::remove' if event.target-scope.$id is $scope.$id

  nav = ms-navigation-service
  if user = Authentication.get-user!
    nav.save-item 'user.profile',  {title : " #{user.fullname}，您好！"   , image: user.avatar,   state : 'app.profile',    weight   : 2,  class: 'profile' }
    nav.save-item 'user.logout',  {title : '退出'   , icon: 'icon-logout',   state : 'app.login',   weight   : 2,  class: 'login'  } if user?
    nav.delete-item 'user.login'
    if user? and user.role is 'admin'
      nav.save-item 'admin',            {title : '系统管理'   , group : true,  weight: 1 }
      nav.save-item 'admin.users',      {title : '用户'      , icon  : 'icon-account-multiple',   state : 'app.admin.users',    weight   : 1 }
    else
      nav.delete-item 'admin'
      nav.delete-item 'admin.users'
  else
    nav.delete-item 'user.profile'
    nav.delete-item 'user.logout'
    nav.save-item 'user.login',  {title : '登录'   , icon: 'icon-login',   state : 'app.login',    weight   : 2,  class: 'logout' } if !user?

  state-change-listener-stop = $root-scope.$on '$stateChangeStart', (event, to-state)!->

  nav.set-folded true

  $root-scope.$on 'destroy', !-> state-change-listener-stop!
