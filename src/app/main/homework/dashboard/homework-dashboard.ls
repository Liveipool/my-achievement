'use strict'

angular.module 'app.homework'

.config ($state-provider) !->
  $state-provider.state 'app.homework.dashboard', {
    url: '/homework/dashboard'
    views:
      'content@app':
        template-url: 'app/main/homework/dashboard/homework-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication)!->
          console.log "欢迎回来!"
          @user = Authentication.get-user!

  }