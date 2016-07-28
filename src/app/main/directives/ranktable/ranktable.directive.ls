'use strict'

angular.module 'app.student'

.directive 'rankTable', ->
    directive-object = 
        template-url: 'app/main/directives/ranktable/ranktable.html'
        scope: 
            classHomeworks: '='
            pagination: '='
            outsideFn: '&onPageChange'
        controller: ($scope, pagination-service)!->
            
            #set up for pagination
            $scope.pagination = pagination-service.get-new!
            $scope.get-num-of-pages = get-num-of-pages
            $scope.pagination.numOfPages = $scope.get-num-of-pages!

            #triggered when the Range of homework change, call the function that has been passed from outside
            $scope.changeRange = !->
                if $scope.outsideFn
                    $scope.outsideFn {currentRange: $scope.classHomeworks.currentRange}
                $scope.pagination.currentPage = 0
                $scope.pagination.numOfPages = $scope.get-num-of-pages!


            function get-num-of-pages 
                Math.ceil($scope.classHomeworks.ranklists[$scope.classHomeworks.currentRange].length/$scope.pagination.pageSize)
            
    directive-object
