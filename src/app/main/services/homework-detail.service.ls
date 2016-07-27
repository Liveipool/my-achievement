'use strict'

angular.module 'fuse'

.service 'homeworkDetailService' !->

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

    @getRanksAndAverScores = (scores, homework-ids, allReviews) ->
        AR = {}
        AR.ranks = []
        AR.averScores = []

        for i from 0 til homework-ids.length
            allScores = []
            allData = _.filter allReviews, (review) -> review.homework_id is homework-ids[i] && review.reviewer.role is 'teacher'

            for j from 0 til allData.length
                allScores.push allData[j].finalScore

            myScore = scores[homework-ids[i]-1]
            rank = getRank myScore, allScores
            averScore = getAverScore allScores
            AR.ranks.push rank
            AR.averScores.push averScore

        AR

    @getHomeworkRanks = (classId, homeworkId, allReviews) !->
        allData = _.filter allReviews, (review) -> review.class is classId && review.homework_id is homeworkId && review.reviewer.role is 'teacher'
        return _.orderBy allData, 'finalScore', 'desc'

