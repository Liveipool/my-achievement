'use strict'

angular.module 'app.student', ['angularFileUpload']

.config ($state-provider)!->
  $state-provider.state 'app.student', {
    abstract: true
  }