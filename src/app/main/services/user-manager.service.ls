'use strict'

angular.module 'fuse'

# admin/
.service 'userManagerService' ($resource, $root-scope, api-resolver)!->
  fields =
    "role",
    "sid",
    "username",
    "fullname",
    "avatar",
    "class",
    "group",
    "email",
    "password",
    "id"

  delete-other-field = (fields, user) ->
    for key, value of user
      if key not in fields
        delete user[key] 
    console.log  user
    user


  @reload-users = ->
    that = @
    # TODO: 向服务器发出请求获取所有user信息
    # console.warn "TODO: function reload-users in userManager"

    api-resolver.resolve 'lb_users@query' 
      .then (result)->
        that.users-cache = result
        $root-scope.$broadcast 'usersUpdate' # 广播更新事件
        Promise.resolve that.users-cache

  @get-users = ->
    if @users-cache
      Promise.resolve @users-cache
    else
      @reload-users!

  #modelId
  @delete-user = (modelId)->
    # TODO: 向服务器发出请求删除用户
    that = @
    console.warn "TODO: function 'delete-user' " + modelId + " in userManager."
    api-resolver.resolve 'lb_delete_user@delete' , {'id': modelId}
    # $resource('http://0.0.0.0:3000/api/Customers/'+modelId).delete!.$promise
      .then (result)->
       console.log 'delete success'
       that.reload-users!
    # 发送http请求后重新加载users，注意this的问题，以下函数一样
    # @reload-users!

  @add-user = (new-user)->
    # TODO: 向服务器发出请求新增用户
    console.warn "TODO: function 'add-user' " + new-user + " in userManager."
    that = @
    # deep copy
    copy-user = JSON.parse(JSON.stringify(new-user))
    copy-user = delete-other-field fields, copy-user
    console.log copy-user
    api-resolver.resolve 'lb_users@save' , copy-user
      .then (user)->
        console.log 'add success'
        that.reload-users!
    # @reload-users!

  @edit-user = (user)->
    # TODO: 向服务器发出请求编辑用户
    that = @
    console.warn "TODO: function 'edit-user' " + user + " in userManager."

    filter = 
      "where" :
        'id' : user.id
    # api-resolver.resolve 'lb_users@save', {'filter': filter}

    # deep copy
    copy-user = JSON.parse(JSON.stringify(user))
    copy-user = delete-other-field fields, copy-user
    console.log copy-user
    $resource('http://0.0.0.0:3000/api/Customers/update?where=%7B%22id%22%3A%22'+copy-user.id+'%22%7D').save(copy-user).$promise
      .then (user)->
        console.log ('edit-user' + ' success')
        # console.log (user)
        that.reload-users!
    # @reload-users!

  @find-user-by-username = (username)->

    filter = 
      "where" :
        'username' : user.username
    api-resolver.resolve 'lb_users@query', {'filter': filter}
      .then (user) ->
        console.log 'find-user-by-username' + "  success"
        Promise.resolve user
    

