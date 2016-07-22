'use strict'

angular.module 'fuse'

# admin/
.service 'userManagerService' ($resource, $root-scope)!->
  @reload-users = ->
    that = @
    # TODO: 向服务器发出请求获取所有user信息
    # console.warn "TODO: function reload-users in userManager"
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
