'use strict'

angular.module 'fuse'

.directive 'reviewList', ->
    directive-object = 
        template-url: 'app/main/directives/review-list/review-list.html'
        scope:
            reviews: "="
        controller: ($scope, homework-review-service)!->
            console.log 'test'

            # functions of the buttons
            $scope.submit = (review)->
              status = homework-review-service.validator review
              if status.state
                review.comment = review.temp-comment
                review.score   = review.temp-score
                homework-review-service.add-review review
                review.editing = false
                review.t-score = "hs"
                # review.error = {}
              else
                review.error = status.error
              console.log review.error
            $scope.edit = (review) ->
              review.editing = true
  
            $scope.update = (review) ->
              status = homework-review-service.validator review
              if status.state
                review.comment = review.temp-comment
                review.score   = review.temp-score
                homework-review-service.update-review review
                review.editing = false
                review.error = {}
              else
                review.error = status.error
              console.log review.error

            $scope.cancel = (review) ->
              homework-review-service.cancel-update-review review
              review.temp-comment = review.comment
              review.temp-score   = review.score
              review.editing      = false
              review.error = {}
  

            # test-submit-review = {
            # "reviewee": {
            # "username": "94971446",
            # "fullname": "郝肥如"
            # },
            # "reviewer": {
            # "username": "45479458",
            # "fullname": "林放高",
            # "role": "student"
            # },
            # "homework_id": 1,
            # "class": 1,
            # "group": 1
            # }

            # $scope.reviews.push test-submit-review

            for r in $scope.reviews
  
              # every can be edited at the beginning
              r.editing = true
  
              # buffer for editing score and comment
              r.temp-score   = r.score
              r.temp-comment = r.comment
  
              # homework image
              r.bg = 'image-div-' + (1 + parse-int 12 * Math.random!)
  
              if r.score
                # if have score means already submit before so can not be edited at the beginning
                r.editing = false
  
                # hs means have score and ns means no score
                # t-score means the translation of score, then put the right class on review
                r.t-score = 'hs'
              else
                r.t-score = 'ns'                


            
    directive-object
