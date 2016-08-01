'use strict'
angular.module 'app.TA'

.config ($state-provider) !->
  $state-provider.state 'app.TA.review-detail', {
    url: '/review-detail?hid&sid'
    views:
        'content@app':
            template-url: 'app/main/TA/review-detail/review-detail.html'
            controller-as: 'vm'
            controller: (Authentication, $state-params)!->
                vm = @
                vm.user = Authentication.get-user!
                console.log $state-params
    }