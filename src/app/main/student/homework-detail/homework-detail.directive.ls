'use strict'

angular.module 'app.student'

.directive 'rankTable', ->
    directive-object = 
        template-url: 'app/main/student/homework-detail/ranktable.html'
        scope: 
            homeworks: '='
            pagination: '='

    directive-object


