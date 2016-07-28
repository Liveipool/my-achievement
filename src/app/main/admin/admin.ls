'use strict'

angular.module 'app.admin', ['angularFileUpload']

.config ($state-provider)!->
  $state-provider.state 'app.admin', {
    abstract: true
    data:
      role: 'admin'
  }

