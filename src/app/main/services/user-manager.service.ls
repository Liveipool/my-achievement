'use strict'

angular.module 'fuse'

# admin/
.service 'userManagerService' ($resource, $root-scope)!->
  @reload-users = ->
    that = @
    # TODO: 向服务器发出请求获取所有user信息
    # console.warn "TODO: function reload-users in userManager"
    $resource('http://0.0.0.0:3000/api/Customers').query!.$promise
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
    $resource('http://0.0.0.0:3000/api/Customers/'+modelId).delete!.$promise
      .then (result)->
       console.log 'delete success'
       that.reload-users!
    # 发送http请求后重新加载users，注意this的问题，以下函数一样
    # @reload-users!

  @add-user = (new-user)->
    # TODO: 向服务器发出请求新增用户
    console.warn "TODO: function 'add-user' " + new-user + " in userManager."
    that = @
    $resource('http://0.0.0.0:3000/api/Customers').save(new-user).$promise
      .then (user)->
        console.log 'add success'
        that.reload-users!
    # @reload-users!

  @edit-user = (user)->
    # TODO: 向服务器发出请求编辑用户
    that = @
    console.warn "TODO: function 'edit-user' " + user + " in userManager."
    $resource('http://0.0.0.0:3000/api/Customers/update?where=%7B%22username%22%3A%22'+user.username+'%22%7D').save(user).$promise
      .then (user)->
        console.log ('edit-user' + ' success')
        # console.log (user)
        that.reload-users!
    # @reload-users!

  @find-user-by-username = (username)->
    $resource('http://0.0.0.0:3000/api/Customers/findOne?filter=%7B%22where%22%3A%20%7B%22username%22%3A%20%'+ username+'%22%7D%7D').get!.$promise
      .then (user) ->
        console.log 'find-user-by-username' + "  success"
        Promise.resolve user

