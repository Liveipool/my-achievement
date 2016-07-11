'use strict'

angular.module 'app.student', ['angularFileUpload']

.config ($state-provider, ms-navigation-service-provider)!->
  $state-provider.state 'app.student', {
    abstract: true
    data:
      role: 'student'
  }

  nav = ms-navigation-service-provider
  nav.save-item 'homework', {title: "作业", group: true, weight: 1, class: 'homework'}

  nav.save-item 'homework.dashboard', {title: "作业详情", weight: 1, icon: 'icon-book-open', state: 'app.student.homework-dashboard'}