'use strict'

angular.module 'app.TA', []

.config ($state-provider)!->
  $state-provider.state 'app.TA', {
    abstract: true
    data:
      role: 'ta'
  }