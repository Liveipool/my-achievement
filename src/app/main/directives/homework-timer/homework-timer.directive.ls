'use strict'

angular.module 'fuse'

.directive 'homeworkTimer', ->
    directiveObject = {
        restrict: 'A'
        template-url: 'app/main/directives/homework-timer/homework-timer.html'
        scope:
            hw-class: "="
        controller: homeworkTimerController
        
    }

!function homeworkTimerController $scope, $interval, timerService then
    $scope.timer-hide = true
    timer = $interval (!-> 
        $scope.remain = timerService.calculateRemain $scope.hw-class.startTime, $scope.hw-class.endTime, $scope.hw-class.status
        $scope.hw-class.status = $scope.remain.status

        if $scope.remain.status == 'future' then $scope.timerHide = false
        if $scope.remain.status == "finish" or $scope.remain.status == 'present'
          $interval.cancel(timer)
          $scope.timerHide = true
        ), 1000