(function ()
{
    'use strict';

    angular
        .module('app.auth.lock', [])
        .config(config)
        .run(runBlock);

    /** @ngInject */
    function config($stateProvider, $translatePartialLoaderProvider, msNavigationServiceProvider)
    {
        // State
        $stateProvider.state('app.lock', {
            url      : '/lock',
            views    : {
                'main@'                      : {
                    templateUrl: 'app/core/layouts/content-only.html',
                    controller : 'MainController as vm'
                },
                'content@app.lock': {
                    templateUrl: 'app/main/auth/lock/lock.html',
                    controller : 'LockController as vm'
                }
            },
            bodyClass: 'lock'
        });

        // Translation
        $translatePartialLoaderProvider.addPart('app/main/auth/lock');

    }

    /** @ngInject */
    function runBlock($rootScope, lockService){
        // Listen Events
        $rootScope.$on('$lock', function(){
            lockService.lock();
        });
    }

})();