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

            // // 每次跳转时都要判断是否有用户已登录
            if (!Authentication.isExists()) {
                //如果没有则查询cookie中是否有用户信息
                Authentication.getCookieUser().then(function(user) {
                    //如果没有则前往登录页面
                    if (!user && toState.name !== 'app.login') {
                        $state.go("app.login");
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