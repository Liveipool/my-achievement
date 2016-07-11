'use strict'

angular.module 'app.admin', []

.config ($state-provider)!->
  $state-provider.state 'app.admin', {
    abstract: true
  }

.service 'userManager', ($resource, $root-scope)!->
  @reload-users = ->
    that = @
    # TODO: 向服务器发出请求获取所有user信息
    console.warn "TODO: function reload-users in userManager"
    $resource('app/data/admin/users.json').get!.$promise
      .then (result)->
        that.users-cache = result.data.users
        $root-scope.$broadcast 'usersUpdate' # 广播更新事件
        Promise.resolve that.users-cache

  @get-users = ->
    if @users-cache
      Promise.resolve @users-cache
    else
      @reload-users!

  @delete-user = (username)->
    # TODO: 向服务器发出请求删除用户
    console.warn "TODO: function 'delete-user' " + username + " in userManager."
    # 发送http请求后重新加载users，注意this的问题，以下函数一样
    @reload-users!

  @add-user = (new-user)->
    # TODO: 向服务器发出请求新增用户
    console.warn "TODO: function 'add-user' " + new-user + " in userManager."
    @reload-users!

  @edit-user = (user)->
    # TODO: 向服务器发出请求编辑用户
    console.warn "TODO: function 'edit-user' " + user + " in userManager."
    @reload-users!

  @find-user-by-username = (username)->
    @get-users!.then (users)->
      user = {}
      for i from 0 to users.length - 1 by 1
        if users[i].username ~= username
          user = users[i]
          break
      Promise.resolve user

.service 'validManager', !->

  @email-valid = (email)->
    # 参照 http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
    # 中 Here's the example of regular expresion that accepts unicode:
    re = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i
    valid = re.test email
    if !valid
      @invalid-arr ||= []
      @invalid-arr.push "邮箱框"
    valid

  @fullname-valid = (fullname)->
    valid = (fullname and fullname !~= "")
    if !valid
      @invalid-arr ||= []
      @invalid-arr.push "姓名框"
    valid

  @username-valid = (username)->
    valid = (username and username !~= "")
    if !valid
      @invalid-arr ||= []
      @invalid-arr.push "用户名框"
    valid

  @password-valid = (pw, repw)->
    valid = (pw and pw !~= "" and pw ~= repw)
    if !valid
      @invalid-arr ||= []
      @invalid-arr.push "密码框"
    valid

  @role-valid = (role)->
    valid = (role ~= "admin" or role ~= "teacher" or role ~= "ta" or role ~= "student")
    if !valid
      @invalid-arr ||= []
      @invalid-arr.push "权限框"
    valid

  @uniform-valid = (user)->
    @username-valid user.username
    @fullname-valid user.fullname
    @role-valid user.role
    @email-valid user.email
    if !(user.role !~= 'student' or (user.class and user.class !~= ''))
      @invalid-arr ||= []
      @invalid-arr.push "班级框"
    
  @add-user-valid = (user)->
    @invalid-arr = []
    @uniform-valid user
    @password-valid user.password, user.repassword
    @invalid-arr

  @edit-user-valid = (user)->
    @invalid-arr = []
    @uniform-valid user
    if !(user.password ~= "" or @password-valid user.password, user.repassword)
      @invalid-arr.push "重复密码框"
    @invalid-arr
