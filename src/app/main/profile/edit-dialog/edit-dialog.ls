'use strict'

angular.module 'app.profile'
  .controller 'edit-dialog-controller', (Authentication, $mdDialog, $interval, $scope) !->
    @user = Authentication.get-user!

    @raw-data =
      sid: @user.sid
      email: @user.email
      old-password: ""

    @is-change = false
    @sid = @user.sid
    @email = @user.email
    @old-password = ""

    @is-changed = false
    @is-correct = false

    @close-edit-dialog = !->
      $mdDialog.hide!


    @change = !->
      if @sid
        if @sid === @raw-data.sid
          is-changed = false
          console.log "no change"
        else
          is-changed = true
          console.log "has change"

    @reset = !->
      @sid = @raw-data.sid
      @email = @raw-data.email
      @old-password = @raw-data.old-password

    @validate-old-password = !->
      console.log @old-password
      console.log valid
      if @old-password == @user.password
        #密码正确
        @is-correct = true
      else
        @is-correct = false
        valid = false
        #密码不正确，将该input设为invalid

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

