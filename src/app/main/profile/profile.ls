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
          @user = @raw-user-data
          #有bug，这里会改变全局的user的role从而导致侧边栏消失

          # _.update @user, 'role', (role)-> if role is 'student' then '学生' else if role is 'admin' then '管理员' else if role is 'ta' then '助教' else if role is 'teacher' then '老师'

          @bg = "bg" + Math.ceil(12 * (Math.random!))

          @openEditDialog = ->
            $mdDialog.show(
              controller-as: 'vm'
              controller: 'edit-dialog-controller'
              template-url: 'app/main/profile/edit-dialog/edit-dialog.html'
              click-outside-to-close: true
            )

    }

