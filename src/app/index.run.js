(function ()
{
    'use strict';

    angular
        .module('fuse')
        .run(runBlock);

    /** @ngInject */
    function runBlock($rootScope, $timeout, $state, Authentication)
    {
        // Activate loading indicator
        var stateChangeStartEvent = $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams)
        {
            $rootScope.loadingProgress = true;

            if (!Authentication.isExists()) {
                console.log("statr authenticate");
                Authentication.getCookieUser().then(function(user) {
                    if (user !== null) {
                        $state.go('app.student.homework.dashboard');
                    }
                    else if (user === null && toState.name !== 'app.login') {
                        $state.go('app.login');
                        event.preventDefault();
                    }
                });
            }

        });

        // De-activate loading indicator
        var stateChangeSuccessEvent = $rootScope.$on('$stateChangeSuccess', function ()
        {
            $timeout(function ()
            {
                $rootScope.loadingProgress = false;
            });
        });

        // Store state in the root scope for easy access
        $rootScope.state = $state;

        // Cleanup
        $rootScope.$on('$destroy', function ()
        {
            stateChangeStartEvent();
            stateChangeSuccessEvent();
        })
    }
})();