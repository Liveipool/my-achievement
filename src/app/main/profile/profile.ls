'use strict'

angular.module 'app.profile', ['angularFileUpload']

.config ($state-provider) !->
  $state-provider.state 'app.profile', {
    # abstract: true
    url: '/profile'
    views:
      'content@app':
        template-url: 'app/main/profile/profile.html'
        controller-as: 'vm'
        controller: (Authentication, $mdDialog) !->
          vm = @
          @raw-user-data = Authentication.get-user!
          @user = @raw-user-data
          @username = @user.username
          @avatar = @user.avatar

          @bg = "bg" + Math.ceil(12 * (Math.random!))

          @openEditDialog = ->
            $mdDialog.show(
              controller-as: 'vm'
              controller: 'edit-dialog-controller'
              template-url: 'app/main/profile/edit-dialog/edit-dialog.html'
            ).finally(!->
              console.log "hahahhh"
              Authentication.update-cookie vm.username .then !->
                # console.log "newUser: ", Authentication.get-user!.avatar
                vm.avatar = Authentication.get-user!.avatar
              )

    }

