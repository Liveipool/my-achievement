'use strict'

angular.module 'fuse'
.directive 'pageHeader', ->
    directive-object = {
        template-url: 'app/main/directives/page-header/page-header.html'
        scope:
            location: '@'
            greeting: '='
            month: '='
        controller: page-header-controller
    }

!function page-header-controller Interaction, $scope
    $scope.theme = Interaction.get-bg-by-month $scope.month


