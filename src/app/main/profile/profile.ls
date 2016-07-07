'use strict'

angular.module 'app.profile', []

.config ($state-provider) !->
  $state-provider.state 'app.profile', {
    # abstract: true
    url: '/profile'
    views:
      'content@app':
        template-url: 'app/main/profile/profile.html'
    }
