'use strict'

angular.module 'app.student', ['angularFileUpload']

.config ($state-provider)!->
  $state-provider.state 'app.student', {
    abstract: true
    data:
      role: 'student'
  }

.service 'reviewManager' ($resource, $root-scope)!->
  @reload-reviews = ->
    that = @
    # TODO: 向服务器发出请求获取所有user信息
    # console.warn "TODO: function reload-reviews in userManager"
    $resource('app/data/faker/reviews.json').get!.$promise
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

  @reviews-filter-by-username = (reviews, username) ->
    reviews-username = [review for review in reviews when review.reviewer.username ~= username]
    Promise.resolve reviews-username
