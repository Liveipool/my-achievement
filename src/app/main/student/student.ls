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