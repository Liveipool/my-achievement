(function ()
{
    'use strict';

    /**
     * Main module of the Fuse
     */
    var modules = GFC.modules.concat(['app.homework']);
    angular
        // .module('fuse', ['app.add-patient', 'app.core', 'app.navigation', 'app.toolbar', 'app.quick-panel',  'app.test', 'app.auth.login', 'app.auth.lock']);
        .module('fuse', modules);

})();