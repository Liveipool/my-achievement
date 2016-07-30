'use strict'

angular.module 'app.profile'
  .controller 'edit-dialog-controller', (Authentication, $mdDialog, FileUploader, $http, $interval) !->
    @user = Authentication.get-user!

    vm = @
    @raw-data =
      sid: @user.sid
      email: @user.email
      old-password: ""
      new-password: ""
      confirm-password: ""

    # @avatar = @user.avatar
    @sid = @user.sid
    @email = @user.email
    @old-password = ""
    @new-password = ""
    @confirm-password = ""
    @is-old-password-correct = false 
    @is-old-password-invalid = false
    @is-new-password-invalid = false
    @is-confirm-password-invalid = false
    @upload-row = false
    @image-invalid = false

    # $http({
    #   method: 'get'
    #   url: 'http://localhost:3005/api/Customers?filter[where][username]=zhangshan'
    # }).then(success = (res) !->
    #   # console.log 'res: ', res.data[0].avatar
    #   vm.avatar = res.data[0].avatar
    #   )

    # 点击更改密码按钮触发
    @change-password = !->
      btn = $ '.change-password-container'
      if @show-or-hide then btn.hide! else btn.show!
      item =  document.get-element-by-id 'dialogContent_dialog'
      scroll = $interval !->
        item.scroll-top += 2
      , 1, 125
      @show-or-hide = !@show-or-hide
      # console.log 'queue.length: ', vm.picture-uploader.queue.length


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

    # 上传图片
    @picture-uploader = new FileUploader {
      # url: 'http://localhost:3000/upload-images'
      # url: "http://localhost:3000/api/Customers/update?where[username]=zhangshan"
      queueLimit: 1
      removeAfterUpload: false
      form-data: [{"avatar": "xxx"}]
      alias: 'upload-images'
    }

    # 点击更改头像按钮清空上传队列
    @clear-picture-item = !->
      vm.cancel!

    @picture-uploader.onAfterAddingFile = (fileItem) !->
      picture = fileItem._file
      # console.log 'picture: ', fileItem
      vm.name = picture.name
      vm.image-invalid = false
      vm.upload-row = true

    @picture-uploader.onWhenAddingFileFailed = !->
      vm.image-invalid = true

    @upload-file = !->
      vm.picture-uploader.uploadAll!
      vm.name = ""
      vm.upload-row = false

    @cancel = !->
      vm.picture-uploader.clearQueue!
      vm.name = ""
      vm.upload-row = false

    @picture-uploader.filters.push({
      name: 'pictureFilter'
      fn: (item) ->
        type = '|' + item.name.slice(item.name.lastIndexOf('.') + 1,item.name.lastIndexOf('.') + 4) + '|';
        '|jpg|png|'.indexOf(type) !== -1
    })

    @picture-uploader.filters.push({
      name: 'pictureSizeFilter'
      fn: (item) ->
        # console.log 'item.size: ', item.size
        item.size <= 1000000
    })
