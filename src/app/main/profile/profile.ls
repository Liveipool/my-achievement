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

          @bg = "bg" + Math.ceil(12 * (Math.random!))

          @openEditDialog = ->
            $mdDialog.show(
              controller-as: 'vm'
              controller: 'edit-dialog-controller'
              template-url: 'app/main/profile/edit-dialog/edit-dialog.html'
              # click-outside-to-close: true
            )

    }

