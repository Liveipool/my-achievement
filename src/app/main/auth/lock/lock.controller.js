(function ()
{
    'use strict';

    angular
        .module('app.auth.lock')
        .controller('LockController', LockController);

    /** @ngInject */
    function LockController(lockService, $rootScope)
    {
        var vm = this;

        // Data
        vm.currentUser = $rootScope.currentUser;
        vm.form = {
            username: lockService.currentUser.fullname
        };

        // Methods
        vm.unlock = function(){
            lockService.unlock(vm.form).then(function(result){
                // console.log('unlock result: ', result);
                vm.isPasswordWrong = result == 'wrong-password';
            });
        }

        vm.changeUser = function(){
            $rootScope.$emit('$logout');
        }
    }
})();