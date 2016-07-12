(function ()
{
    'use strict';

    angular
        .module('fuse')
        .config(config);

    /** @ngInject */
    function config($stateProvider)
    {
        // Put your custom configurations here
        $stateProvider.state('app.access-denied', {
          url: '/access-denied',
          view: {
            'main@': {
              templateUrl: 'app/core/layouts/content-only.html',
              controller: 'MainController as vm'
            },
            'content@app.access-denied': {
              templateUrl: 'app/main/404.html'
            }
          }
        });
    }

})();