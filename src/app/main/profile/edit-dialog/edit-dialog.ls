'use strict'

angular.module 'app.profile'
  .controller 'edit-dialog-controller', (Authentication, $mdDialog, $interval, FileUploader) !->
    @user = Authentication.get-user!
    vm = @
    @raw-data =
      sid: @user.sid
      email: @user.email
      old-password: ""
      new-password: ""
      confirm-password: ""

    @sid = @user.sid
    @email = @user.email
    @old-password = ""
    @new-password = ""
    @confirm-password = ""
    @is-old-password-correct = false 
    @is-old-password-invalid = false
    @is-new-password-invalid = false
    @is-confirm-password-invalid = false

    @change-password = !->
      btn = $ '.change-password-container'
      if @show-or-hide then btn.hide! else btn.show!
      item =  document.get-element-by-id 'dialogContent_dialog'
      scroll = $interval !->
        item.scroll-top += 2
      , 1, 125
      @show-or-hide = !@show-or-hide

    @validate-old-password = !->
      if @old-password == @user.password
        @is-old-password-correct = true
        @is-old-password-invalid = false
      else
        @is-old-password-correct = false
        @is-old-password-invalid = true

    @check-new-password-valid = !->
      if @new-password.search(/\w{6,18}/) === -1
        @is-new-password-invalid = true
      else
        @is-new-password-invalid = false

    @check-confirm-password-valid = !->
      if @confirm-password !== @new-password
        @is-confirm-password-invalid = true
      else
        @is-confirm-password-invalid = false

    @close-edit-dialog = !->
      $mdDialog.hide!

    @save = !->
      @user.email = @email
      @user.sid = @sid
      if @new-password !== ""
        @user.password = @new-password
      $mdDialog.hide!

    @reset = !->
      @sid = @raw-data.sid
      @email = @raw-data.email
      @old-password = @raw-data.old-password
      @new-password = @raw-data.new-password
      @confirm-password = @raw-data.confirm-password
      @is-old-password-correct = false
      @is-old-password-invalid = false
      @is-new-password-invalid = false
      @is-confirm-password-invalid = false

    
    @picture-uploader = new FileUploader {
      # url: '' 连接到对应api
      queueLimit: 1
      removeAfterUpload: false
      # method: "post"
    }

    @clear-picture-item = !->
      # console.log "vm.picture-uploader.queue.length: ", vm.picture-uploader.queue.length
      vm.cancel!

    @picture-uploader.onAfterAddingFile = (fileItem) !->
      picture = fileItem._file
      vm.name = picture.name

    @upload-file = !->
      vm.picture-uploader.uploadAll!
      vm.cancel!

    @cancel = !->
      vm.picture-uploader.clearQueue!
      vm.name = ""

    @picture-uploader.filters.push({
        name: 'pictureFilter',
        fn: (item) ->
          type = '|' + item.name.slice(item.name.lastIndexOf('.') + 1,item.name.lastIndexOf('.') + 4) + '|';
          '|jpg|png|'.indexOf(type) !== -1
    });
