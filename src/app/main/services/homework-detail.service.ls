'use strict'

angular.module 'fuse'

.service 'homeworkDetailService' !->

    sortByScore = (a, b) -> b - a

    getRank = (myScore, allScores) !->
        allScores.sort sortByScore
        for i from 1 to allScores.length
            if allScores[i-1] == myScore then return i

    @getRanks = (scores, homework-ids, allReviews) !->
        ranks = []

        for i from 0 til homework-ids.length
            allScores = []
            allDatas = _.filter allReviews, (review) -> review.homework_id is homework-ids[i] && review.reviewer.role is 'teacher'

            for j from 0 til allDatas.length
                allScores.push allDatas[j].finalScore

            myScore = scores[homework-ids[i]-1]
            rank = getRank myScore, allScores
            ranks.push rank
        return ranks

