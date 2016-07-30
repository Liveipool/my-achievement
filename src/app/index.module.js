(function ()
{
    'use strict';

    /**
     * Main module of the Fuse
     */

    var modules = ['app.core', 'app.navigation', 'app.toolbar', 'app.quick-panel', 'app.auth.login', 'app.auth.lock','app.admin', 'app.student', 'app.TA', 'app.profile', 'app.teacher'];

    angular
        // .module('fuse', ['app.add-patient', 'app.core', 'app.navigation', 'app.toolbar', 'app.quick-panel',  'app.test', 'app.auth.login', 'app.auth.lock']);
        .module('fuse', modules);

})();
