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

                Authentication.getCookieUser().then(function(user) {

                    if (user !== null ) {

                        if (!Authentication.isToStateAuthenticated(toState)) {
                            event.preventDefault();
                            $state.go('app.access-denied');
                        }
                        else if (toState.name == 'app.login') {
                            var dest = Authentication.filterRoute(user);
                            $state.go(dest);
                        }

                    }
                    else if (user === null && toState.name !== 'app.login' && toState.name !== 'app.access-denied') {
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