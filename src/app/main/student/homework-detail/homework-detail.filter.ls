'use strict'

angular.module 'app.student'

.filter 'startFrom', ->
    (input, start)->
        if (input === undefined)
            return input
        else
            return input.slice +start
