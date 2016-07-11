'use strict'

angular.module 'app.TA', []

.config ($state-provider, ms-navigation-service-provider)!->
  $state-provider.state 'app.TA', {
    abstract: true
    data:
      role: 'ta'
  }
  nav = ms-navigation-service-provider
  nav.save-item 'TA', {title: "作业情况", group: true, weight: 1}

  nav.save-item 'TA.dashboard', {title: "作业列表", weight: 1, icon: 'icon-book-open', state: 'app.TA.review-list'}
