'use strict'

angular.module 'fuse'

.config ($state-provider) !->
  $state-provider.state 'app.error-404', {
    url: '/error-404',
    views: {
      'main@': {
        templateUrl: 'app/core/layouts/content-only.html',
        controller: 'MainController as vm'
      },
      'content@app.error-404': {
        templateUrl: 'app/main/errors/error-404.html'
      }
    }
  }