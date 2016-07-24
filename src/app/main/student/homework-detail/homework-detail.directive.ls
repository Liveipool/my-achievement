'use strict'

angular.module 'app.student'

.directive 'rankTable', ->
    directive-object = 
        template-url: 'app/main/student/homework-detail/ranktable/ranktable.html'
        scope: 
            classHomeworks: '='
            pagination: '='
            resetPage: '&onPageChange'
        controller: ($scope)!->
            console.log $scope.classHomeworks
            
    directive-object

