'use strict'



angular.module 'fuse' 

.config navigations = ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider)!->
  'ngInject'
  nav = ms-navigation-service-provider  




  # --------- 菜单 ----------- #
  nav.save-item 'example',          {title : '示例'     , group : true,  weight: 1 } # 分组用来容纳示例
    

  nav.save-item 'user',  {title : "用户"   , group: true,   weight   : 2,  class: 'user' } 

.controller 'MainController', ($scope, $root-scope, ms-navigation-service, $state)!->
  'ngInject'
  # Remove the splash screen
  $scope.$on '$viewContentAnimationEnded', (event)-> $root-scope.$broadcast 'msSplashScreen::remove' if event.target-scope.$id is $scope.$id

  nav = ms-navigation-service
  if user = $root-scope.current-user
    nav.save-item 'user.profile',  {title : "#{user.fullname}，您好！"   , image: user.avatar,   state : 'app.profile',    weight   : 2,  class: 'profile' } 
    nav.save-item 'user.logout',  {title : '退出'   , icon: 'icon-logout',   state : 'app.login',   weight   : 2,  class: 'login'  } if user?
    nav.delete-item 'user.login'
  else
    nav.delete-item 'user.profile'
    nav.delete-item 'user.logout'
    nav.save-item 'user.login',  {title : '登录'   , icon: 'icon-login',   state : 'app.login',    weight   : 2,  class: 'logout' } if !user?
  
  state-change-listener-stop = $root-scope.$on '$stateChangeStart', (event, to-state, from-state)!->

    # --------------------- 管理员视图 ---------------------------- #
    
    if $root-scope.current-user? and 'admin' in $root-scope.current-user.roles
      nav.save-item 'admin',            {title : '系统管理'   , group : true,  weight: 1 }
      nav.save-item 'admin.users',      {title : '用户'      , icon  : 'icon-account-multiple',   state : 'app.admin.users',    weight   : 1 }
      nav.save-item 'admin.companies',  {title : '公司'      , image  : '/assets/images/menu/company.svg',   state : 'app.admin.companies',    weight   : 1 }
    else
      nav.delete-item 'admin'
      nav.delete-item 'admin.users'
      nav.delete-item 'admin.companies'


  nav.set-folded true

  $root-scope.$on 'destroy', !-> state-change-listener-stop!
