'use strict'

angular.module 'fuse'

.controller 'MainController', ($scope, $root-scope, ms-navigation-service, $state, Authentication)!->
  'ngInject'

  # Remove the splash screen
  $scope.$on '$viewContentAnimationEnded', (event)-> $root-scope.$broadcast 'msSplashScreen::remove' if event.target-scope.$id is $scope.$id

  nav = ms-navigation-service
  auth = Authentication

  user = auth.get-user!

  nav.set-folded true

  nav.save-item 'user',  { title: "用户", group: true, weight: 2, class: 'user' }

  if user
    nav.save-item 'user.profile', { title: " #{user.fullname}，您好！", image: user.avatar, state: 'app.profile', weight: 2, class: 'profile' }

    nav.save-item 'user.logout', { title: '退出', icon: 'icon-logout', state: 'app.login',weight: 2, class: 'login' }
    nav.delete-item 'user.login'

    #---------目前只能在这里设置菜单栏-----------#

    #---admin---#
    nav.save-item 'admin', {title: '用户管理', group: true, weight: 2 , hidden: -> auth.isnt-admin}
    nav.save-item 'admin.all-users', {title: '所有用户', icon: 'icon-account-multiple', state: 'app.admin.all-users', weight: 2 , hidden: -> auth.isnt-admin user}
    nav.save-item 'admin.add-user', {title: '添加用户', icon: 'icon-account-plus',state: 'app.admin.add-user', weight: 2, hidden: -> auth.isnt-admin user }

    #---student---#
    nav.save-item 'student', {title: "作业", group: true, weight: 1, class: 'homework', hidden: -> auth.isnt-student user}
    nav.save-item 'student.homework-dashboard', {title: "作业列表", weight: 1 ,icon: 'icon-book-open' ,state: 'app.student.homework-dashboard', hidden: -> auth.isnt-student user}
    nav.save-item 'student.homework-detail', {title: "作业详情", weight: 1, icon: 'icon-border-color',state: 'app.student.homework-detail', hidden: -> auth.isnt-student user}

    #---teacher---#
    nav.save-item 'teacher',  {title : "作业"   , group: true,   weight   : 1 , class: 'teacher', hidden: -> auth.isnt-teacher user}
    nav.save-item 'teacher.homeworks-list',  {title : "所有作业"   , icon: 'icon-book-open', state: 'app.teacher.homework-list',   weight : 1, class: 'teacher', hidden: -> auth.isnt-teacher user }
    nav.save-item 'teacher.publish-homework', {title: "添加作业", icon: 'icon-border-color', state: 'app.teacher.publish-homework', weight: 1, class: 'teacher', hidden: -> auth.isnt-teacher user}

    #---TA---#
    nav.save-item 'TA', {title: "作业", group: true, weight: 1, hidden: -> auth.isnt-TA user}
    nav.save-item 'TA.review-list', {title: "作业列表", weight: 1, icon: 'icon-book-open', state: 'app.TA.review-list', hidden: -> auth.isnt-TA user}

  else
    nav.delete-item 'user.profile'
    nav.delete-item 'user.logout'
    nav.save-item 'user.login',  {title: '登录', icon: 'icon-login', state: 'app.login', weight: 2, class: 'logout' } if !user?

  state-change-listener-stop = $root-scope.$on '$stateChangeStart', (event, to-state)!->

  $root-scope.$on 'destroy', !-> state-change-listener-stop!


