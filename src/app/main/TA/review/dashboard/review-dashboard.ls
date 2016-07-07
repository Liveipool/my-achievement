'use strict'

angular.module 'app.TA'

.config ($state-provider) !->
  $state-provider.state 'app.TA.review.dashboard', {
    url: '/homework/TA-review-list'
    resolve:
      data: (api-resolver) -> api-resolver.resolve('classes@get')
    views:
      'content@app':
        template-url: 'app/main/TA/review/dashboard/review-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, data, DTOptionsBuilder)!->
          console.log "review-dashboard"
          #console.log(data.data);
          @user = Authentication.get-user!
          @classes = data.data
          @dtOptions = DTOptionsBuilder.newOptions! .withDisplayLength 10 .withPaginationType 'simple'
          console.log @dtOptions
  }
