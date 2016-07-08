'use strict'

angular.module 'app.admin', []

.config ($state-provider)!->
  $state-provider.state 'app.admin', {
    abstract: true
  }