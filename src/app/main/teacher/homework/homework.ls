'use strict'

angular.module 'app.teacher'

.config ($state-provider,  ms-navigation-service-provider) !->
  $state-provider.state 'app.teacher.homework', {
    abstract: true
  }
