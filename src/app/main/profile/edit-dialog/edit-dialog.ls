'use strict'

angular.module 'app.profile'
  .controller 'edit-dialog-controller', (Authentication, $mdDialog) !->
    @user = Authentication.get-user!
    @show-or-hide = false
    @isChanged = false
    # console.log @user
    # console.log document.getElementById("sid")
    @close-edit-dialog = !->
      $mdDialog.hide!

    @save-changes = !->
      @user.fullname = document.getElementById("fullname").value
      @user.email = document.getElementById("email").value
      @user.sid = document.getElementById("sid").value
      $mdDialog.hide!

    @clear-changes = !->
      document.getElementById("fullname").value = @user.fullname
      document.getElementById("email").value = @user.email
      document.getElementById("sid").value = @user.sid
      document.getElementById("oldPassword").value = ""
      document.getElementById("newPassword").value = ""
      document.getElementById("repeatNewPassword").value = ""
      document.getElementById("oldPassword").focus()
      document.getElementById("oldPassword").blur()
      document.getElementById("newPassword").focus()
      document.getElementById("newPassword").blur()
      document.getElementById("repeatNewPassword").focus()
      document.getElementById("repeatNewPassword").blur()

    @change-password = !->
      # console.log @show-or-hide
      @show-or-hide = !@show-or-hide
      if @show-or-hide == true
        document.getElementById("changePassword").className += ' md-raised md-hue-1 grey-50-fg'
      else
        document.getElementById("changePassword").className -= ' md-raised md-hue-1 grey-50-fg'

    # @checkChange = (id) !->
    #   if document.getElementById(id).value != @user.id
    #     @isChanged = true
    #   console.log @isChanged
    # console.log document.getElementById("fullname")
    # document.getElementById("fullname").addEventListener 'blur', !->
    #   if document.getElementById("fullname").value != @user.fullname
    #     @isChanged = true
