'use strict'

angular.module 'fuse'

# admin/
.service 'validManagerService' !->

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