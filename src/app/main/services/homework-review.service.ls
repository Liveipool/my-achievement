'use strict'

angular.module 'fuse'

# student/homework-reviw
.service 'homeworkReviewService' ($resource, $root-scope, api-resolver)!->
  @reload-reviews = ->
    that = @
    # TODO: 向服务器发出请求获取所有user信息
    # console.warn "TODO: function reload-reviews in userManager"
    # $resource('app/data/review/reviews.json').get!.$promise
    #   .then (result)->
    #     that.reviews-cache = result.data
    #     # console.log(that.reviews-cache)
    #     $root-scope.$broadcast 'reviewsUpdate' # 广播更新事件
    #     Promise.resolve that.reviews-cache


  @get-myscore-reviews = (user, homework_id)->
    
    console.log user, homework_id
    filter = {
      "where":
          "reviewee.username": user.username
          "homework_id": homework_id
    }
    
    api-resolver.resolve 'lb_reviews@query', {"filter": filter}
    
  @get-group-reviews = (user, homework_id) ->
    
    filter = {
      "where":
          "reviewer.username": user.username
          "homework_id": homework_id
    }

    api-resolver.resolve 'lb_reviews@query', {"filter": filter}
    


  @cancle-update-review = ->
    # reload-reviews then the change is undo in the controller
    # acctually do nothing is OK
    console.log "cancle-update-review!"
    @reload-reviews!

  @add-review = (review) ->
    console.log review
    api-resolver.resolve 'lb_reviews@save', review
    .then (result) !->
      console.log result
      console.log "add-review!"
    @reload-reviews!

  @update-review = (review) ->
    console.log "update-review!"
    where_filter = {"reviewer.username": review.reviewer.username, "reviewee.username": review.reviewee.username, homework_id: review.homework_id}
    where_filter =  JSON.stringify where_filter
    url = 'http://localhost:3000/api/Reviews/update?where=' + where_filter
    $resource(url).save review 
    
    @reload-reviews!

  @validator = (review) ->
    # console.log review

    temp-score = parse-int review.temp-score, 10
    # console.log typeof temp-score, temp-score

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
