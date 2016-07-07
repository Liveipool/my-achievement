'use strict'

angular.module 'app.student', []

.config ($state-provider)!->
  $state-provider.state 'app.student', {
    abstract: true
  }