'use strict'

angular.module 'fuse'

.service 'homeworkDetailService' ($resource) !->

    sortByScore = (a, b) -> b - a

    getRank = (myScore, allScores) !->
        allScores.sort sortByScore
        for i from 1 to allScores.length
            if allScores[i-1] == myScore then return i

    getAverScore = (allScores) !->
        sum = 0
        for i from 0 til allScores.length
            sum += allScores[i]
        averScore = sum/allScores.length
        return averScore.toFixed(1)

    @getHomeworks = ->
        $resource('http://localhost:3000/api/Homework').query!.$promise
          .then (result)->
            Promise.resolve result

    @getScoresAndHomeworkIds = (user) ->
        $resource 'http://localhost:3000/api/Reviews', {
            filter:
              "where":
                "reviewee.username": user.username
                "reviewer.role": "teacher"
        } .query!.$promise
        .then (result) ->
            scores = [review.score for review in result]
            homework-ids = [review.homework_id for review in result]
            Promise.resolve {scores: scores, homework-ids: homework-ids}



    @getRanksAndAverScores = (scores, homework-ids) ->
        $resource 'http://localhost:3000/api/Reviews', {
            filter:
                "where":
                    "reviewer.role": 'teacher' 
        } .query!.$promise
        .then (result) ->
            AR = {}
            AR.ranks = []
            AR.averScores = []

            for i from 0 til homework-ids.length
                allScores = []
                allData = _.filter result, (review) -> review.homework_id is homework-ids[i]

                for j from 0 til allData.length
                    allScores.push allData[j].finalScore

                myScore = scores[homework-ids[i]-1]
                rank = getRank myScore, allScores
                averScore = getAverScore allScores
                AR.ranks.push rank
                AR.averScores.push averScore

            Promise.resolve AR

    @getHomeworkRanks = (classId, homeworkId, allReviews) ->
        $resource 'http://localhost:3000/api/Reviews', {
            filter:
                "where":
                    "class": classId
                    "homework_id": homeworkId
                    "reviewer.role": 'teacher'
        } .query!.$promise
        .then (result) ->
            orderData = _.orderBy result, 'finalScore', 'desc'
            Promise.resolve _.orderBy result, 'finalScore', 'desc'

