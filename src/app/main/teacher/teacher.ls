'use strict'

angular.module 'app.teacher', []

.config ($state-provider,  ms-navigation-service-provider) !->
  $state-provider.state 'app.teacher', {
    abstract: true
    data:
        role: 'teacher'
  }



.config navigations = ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider)!->
  'ngInject'
  nav = ms-navigation-service-provider

  nav.save-item 'homeworks',  {title : "作业情况"   , group: true,   weight   : 2 , class: 'homeworks'}
  nav.save-item 'homeworks.list',  {title : "所有作业"   , icon: 'icon-book-open', state: 'app.teacher.homework.list',   weight   : 1 }

