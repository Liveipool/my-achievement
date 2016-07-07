'use strict'

angular.module 'app.teacher', []

.config ($state-provider,  ms-navigation-service-provider) !->
  $state-provider.state 'app.teacher', {
    abstarct: true
  }



.config navigations = ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider)!->
  'ngInject'
  nav = ms-navigation-service-provider

  nav.save-item 'homeworks',  {title : "作业情况"   , group: true,   weight   : 2 , class: 'homeworks'}
  nav.save-item 'homeworks.all-homeworks',  {title : "查看所有作业"   , icon: 'icon-book-open', state: 'app.teacher.all-homeworks',   weight   : 1 }

