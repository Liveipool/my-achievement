'use strict'

angular.module 'app.TA'

.config ($state-provider)!->
    $state-provider.state 'app.TA.dashboard', {
        url: '/TA/dashboard'
        resolve: 
            homeworks: (api-resolver)-> api-resolver.resolve 'homeworks@get'
        views:
            'content@app':
                template-url: 'app/main/TA/dashboard/dashboard.html'
                controller-as: 'vm'
                controller: TADashboardController
    }

!function TADashboardController homeworks, Authentication
    vm = @
    vm.homeworks = homeworks.data
    vm.user = Authentication.get-user!
