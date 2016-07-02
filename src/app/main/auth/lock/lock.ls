'use strict'

angular.module 'app.auth.lock', []

.config ($state-provider) !->
  $state-provider.state 'app.lock', { abstarct: true }