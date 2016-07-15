'use strict'

angular.module 'app.profile'
  .controller 'edit-dialog-controller', (Authentication, $mdDialog, $interval) !->
    @user = Authentication.get-user!
    @show-or-hide = false
    @isChanged = false
    @close-edit-dialog = !->
      $mdDialog.hide!

    @change-password = !->
      btn = $ '.change-password-container'
      if @show-or-hide then btn.hide! else btn.show!
      item =  document.get-element-by-id 'dialogContent_dialog'
      scroll = $interval !->
        item.scroll-top += 2
      , 1, 125

      @show-or-hide = !@show-or-hide

      # if @show-or-hide == true
      #   document.getElementById("changePassword").className += ' md-raised md-hue-1 grey-50-fg'
      # else
      #   document.getElementById("changePassword").className -= ' md-raised md-hue-1 grey-50-fg'

