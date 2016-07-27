'use strict'

angular.module 'fuse'

.directive 'homeworkList', ->
    directiveObject = {
        template-url: 'app/main/directives/homework-list/homework-list.html'
        scope:
            homeworks: "="
            role: "="
        controller: homeworkListController
    }


!function homeworkListController $scope, $state then
    $scope.is-teacher = ->
        $scope.role == 'teacher'


    if $scope.homeworks
        $scope.homeworks = calculate-status $scope.homeworks

        console.log $scope.homeworks

    $scope.edit-homework = (hid) ->
        $state.go 'app.teacher.edit-homework', {id : hid}

    $scope.review-homework = (hid) ->
        if $scope.role == 'teacher'
            $state.go 'app.teacher.review-homework', {id : hid}
        else if $scope.role == 'ta'
            $state.go 'app.TA.review-list', {id: hid}  

    function calculate-status hs
        for h in hs
          #矫正假数据中，status随着时间推移而产生错误的影响
          for c in h.classes
            nowTime = new Date!
            startTime = new Date c.startTime
            endTime = new Date c.endTime
            if nowTime < startTime 
              c.status = 'future'
            else if nowTime < endTime
              c.status = 'present'
            else 
              c.status = 'finish'
              

          if status-helper h.classes, 'present'
            h.status = 'present'
            h.t-status = '进行中'
          else
            if status-helper h.classes, 'future'
              h.status = 'future'
              h.t-status = '未开始'
            else
              h.status = 'finish'
              h.t-status = '已结束'
        for h in hs
          h.bg = 'image-div-' + (1 + parse-int 12 * Math.random!)
          h.description = 'https://' + h.description if not /http/.test h.description
          # avoid missing the 'http'
          for c in h.classes
            c.t-status = '进行中' if c.status == 'present'
            c.t-status = '未开始' if c.status == 'future'
            c.t-status = '已结束' if c.status == 'finish'
        hs

    function status-helper classes, status
        for c in classes
            if c.status == status
                return true
        false