'use strict'

angular.module 'app.student', ['angularFileUpload', 'chart.js']

.config ($state-provider)!->
  $state-provider.state 'app.student', {
    abstract: true
  }