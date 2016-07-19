'use strict'

angular.module 'fuse'

# student/homework-reviw
.service 'homeworkReviewService' ($resource, $root-scope)!->
  @reload-reviews = ->
    that = @
    # TODO: 向服务器发出请求获取所有user信息
    # console.warn "TODO: function reload-reviews in userManager"
    $resource('app/data/review/reviews.json').get!.$promise
      .then (result)->
        that.reviews-cache = result.data
        # console.log(that.reviews-cache)
        $root-scope.$broadcast 'reviewsUpdate' # 广播更新事件
        Promise.resolve that.reviews-cache

  @get-all-reviews = ->
    if @reviews-cache
      Promise.resolve @reviews-cache
    else
      @reload-reviews!

  # get the reviews which are needed, using promise so can thenable filtering
  @reviews-filter-by-id = (reviews, id) ->
    reviews-id = [review for review in reviews when review.homework_id ~= id]
    Promise.resolve reviews-id

  # gr means group review and ms means my score
  @reviews-filter-by-username = (reviews, username) ->
    reviews-username-gr = [review for review in reviews when review.reviewer.username ~= username]
    reviews-username-ms = [review for review in reviews when review.reviewee.username ~= username]
    Promise.resolve { "gr" : reviews-username-gr, "ms" : reviews-username-ms }


  @cancle-update-review = ->
    # reload-reviews then the change is undo in the controller
    # acctually do nothing is OK
    console.log "cancle-update-review!"
    @reload-reviews!

  @add-review = (review) ->
    # TODO: add-review
    console.log "add-review!"
    @reload-reviews!

  @update-review = (review) ->
    #TODO: update-review
    console.log "update-review!"
    @reload-reviews!

  @validator = (review) ->
    console.log review

    temp-score = parse-int review.temp-score, 10
    console.log typeof temp-score, temp-score

    @status = {}
    @status.error = {}

    @status.state = true
    if !(0 < temp-score && temp-score <= 100)
      @status.state = false
      @status.error.score = "请输入正确的评分"
    if !review.temp-comment
      @status.state = false
      @status.error.comment = "请输入正确的评论"

    return @status

# TA/review-list
.service 'reviewListService' ($location, $anchor-scroll)!->
  @go-to-anchor = (class-id, group-id) ->
    new-hash = "class" + class-id + "-group" + group-id
    if $location.hash! !== new-hash
      $location.hash new-hash
    else
      $anchor-scroll!

  @get-student-users-by-class = (users) ->
    _.filter users, 'class'

  @get-classes = (student-users) ->
    _classes = _.groupBy student-users, 'class'
    # console.log _classes
    classes = []
    for id of _classes
      groups = []
      _groups = _.groupBy _classes[id], 'group'
      for _id of _groups
        groups.push {id: _id, members: _groups[_id]}
      classes.push {id: id, groups: groups, members: _classes[id]}
    return classes

# student/homework-detail
.factory 'paginationService' ->
    pagination = {}

    pagination.get-new = (perPage)->

        if perPage === undefined
            perPage = 10

        console.log perPage

        paginator = 
            numOfPages: 1
            pageSize: perPage
            currentPage: 0

        paginator.prev-page = !->
            if not paginator.is-first-page!
                paginator.currentPage -= 1

        paginator.next-page = !->
            if not paginator.is-last-page!
                paginator.currentPage += 1

        paginator.is-last-page = ->
            paginator.currentPage >= paginator.numOfPages - 1

        paginator.is-first-page = ->
            paginator.currentPage == 0

        paginator
    pagination

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
