'use strict'

angular.module 'app.profile', []

.config ($state-provider) !->
  $state-provider.state 'app.profile', {
    # abstract: true
    url: '/profile'
    views:
      'content@app':
        template-url: 'app/main/profile/profile.html'
        controller-as: 'vm'
        controller: (Authentication, $mdDialog) !->
          @raw-user-data = Authentication.get-user!
          @user = _.update @raw-user-data, 'role', (role)-> if role is 'student' then '学生' else if role is 'admin' then '管理员' else if role is 'ta' then 'TA' else if role is 'teacher' then '老师'
          @bg = "bg" + Math.ceil(12 * (Math.random!))
          # @change-password-count = 0
          # @change-password-hint = "下一步"
          # that = @
          # @change-password = ->
          #   that.change-password-count++
          #   # console.log("change-password-count: ", that.change-password-count)
          #   that.change-password-hint = if that.change-password-count is 2 then '确认更改' else '下一步'
          # # console.log(@change-password-count)
          # @clear = ->
          #   that.change-password-count = 0
          @openEditDialog = ->
            $mdDialog.show({
              # controller: 'editDialogController'
              # controller-as: 'vm'
              template-url: 'app/main/profile/edit-dialog/edit-dialog.html'
              click-outside-to-close: true
            })

        # function openTaskDialog(ev, task)
        # {
        #     $mdDialog.show({
        #         controller         : 'TaskDialogController',
        #         controllerAs       : 'vm',
        #         templateUrl        : 'app/main/apps/todo/dialogs/task/task-dialog.html',
        #         parent             : angular.element($document.body),
        #         targetEvent        : ev,
        #         clickOutsideToClose: true,
        #         locals             : {
        #             Task : task,
        #             Tasks: vm.tasks,
        #             event: ev
        #         }
        #     });
        # }
    }

