'use strict'

angular.module 'app.student'

# .controller 'hwTimer', ($scope, $interval, timerService) !->
#   $scope.timerHide = true
#   timer = $interval (!->
#     $scope.remain = timerService.calculateRemain $scope.homework.classes[0].startTime, $scope.homework.classes[0].endTime, $scope.homework.classes[0].status
#     $scope.homework.classes[0].status = $scope.remain.status
#     if $scope.remain.status == 'future' then $scope.timerHide = false
#     if $scope.remain.status == "finish" or $scope.remain.status == 'present'
#       $interval.cancel(timer)
#       $scope.timerHide = true
#     ), 1000


# .factory 'timerService', ->
#   calculate = (start, end, status) ->
#     nowTime = new Date!
#     startTime = new Date start
#     endTime = new Date end

#     if nowTime < startTime
#       status = 'future'
#       iRemain = (startTime.getTime! - nowTime.getTime!)/1000
#     else if nowTime < endTime
#       status = 'present'
#       iRemain = (endTime.getTime! - nowTime.getTime!)/1000
#     else
#       status = 'finish'
#       iRemain = 0

#     remain = {}
#     remain.days =  parseInt iRemain/86400
#     iRemain %= 86400
#     remain.hours = parseInt iRemain/3600
#     iRemain %= 3600
#     remain.mins = parseInt iRemain/60
#     iRemain %= 60
#     remain.secs = parseInt iRemain
#     remain.status = status

#     timeSum = 0
#     for key, value of remain
#       timeSum = timeSum + value
#     if timeSum == 0 and status == 'future' then remain.status = 'present'
#     if timeSum == 0 and status == 'present' then remain.status = 'finish'
#       # body...
#     remain

#   calculateRemain: (start, end, status)->
#     calculate start, end, status





.config ($state-provider) !->
  $state-provider.state 'app.student.homework-dashboard', {
    url: '/homework-dashboard'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data
            Promise.resolve homeworks

      homework-detail: ($resource, Authentication, homework-detail-service) ->
        $resource 'app/data/review/reviews.json' .get!.$promise
        .then (result) ->
          allReviews = result.data
          user = Authentication.get-user!
          reviews = _.filter result.data, (review) -> review.reviewee.username == user.username && review.reviewer.role is 'teacher'
          scores = [review.score for review in reviews]
          homework-ids = [review.homework_id for review in reviews]

          AR = homework-detail-service.getRanksAndAverScores scores, homework-ids, allReviews # AR stores average scores and ranks
          ranks = homework-detail-service.getHomeworkRanks 1, 2, allReviews
          Promise.resolve {scores: scores, homework-ids: homework-ids, AR: AR}

    data:
      role: 'student'

    views:
      'content@app':
        template-url: 'app/main/student/homework-dashboard/homework-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks, $mdDialog, homework-detail)!->

          arr2string = (arr)->
            _string = ""
            i = 0
            while i != arr.length - 1
              _string += arr[i] + ','
              i++
            _string += arr[i]
            return _string

          vm = @
          vm.user = Authentication.get-user!
          vm.homework-ids = arr2string homework-detail.homework-ids
          vm.scores = homework-detail.scores
          vm.stringScores = arr2string vm.scores
          vm.ranks = homework-detail.AR.ranks
          vm.stringRanks = arr2string vm.ranks
          vm.averScores = homework-detail.AR.averScores  #平均分数组


          vm.homeworks = homeworks


          for homework in vm.homeworks
            _.remove homework.classes, (c) -> c.class_id isnt vm.user.class



          vm.style =
            future:
              status: '未开始'
              fg: "light-blue-fg"
            present:
              status: "进行中"
              fg: "red-fg"
            finish:
              status: "已结束"
              fg: "grey-fg"

          vm.switch =
            future: true
            present: true
            finish: true

          vm.tickFormat = (d)!->
            if (d == 0)
              return 1
            else
              return d

          $scope.jump = (description)!->
            window.open description   # description必须为绝对地址

          $scope.showSubmitDialog = (id)!->
            $mdDialog.show {
              templateUrl: 'app/main/student/homework-dashboard/submitDialog.html',
              parent: angular.element(document.body),
              clickOutsideToClose: false,
              controller: ($scope, $mdDialog, FileUploader, $interval) !->
                $scope.id = id
                $scope.showProgress = false

                $scope.cancel = !->
                  $mdDialog.hide!

                pictureUploader = $scope.pictureUploader = new FileUploader {
                  # url: 'upload.php',
                  queueLimit: 1,
                  removeAfterUpload: false
                }

                coreUploader = $scope.coreUploader = new FileUploader {
                  # url: 'upload.php',
                  queueLimit: 1,
                  removeAfterUpload: false
                }

                $scope.clearPictureItem = !->
                  pictureUploader.clearQueue!

                $scope.clearCoreItem = !->
                  coreUploader.clearQueue!

                pictureUploader.onAfterAddingFile = (fileItem) !->
                  $scope.picture = fileItem._file

                coreUploader.onAfterAddingFile = (fileItem) !->
                  $scope.core = fileItem._file

                $scope.uploadFile = !->
                  $scope.showProgress = true
                  pictureUploader.uploadAll();
                  coreUploader.uploadAll();

                pictureUploader.filters.push({
                    name: 'pictureFilter',
                    fn: (item) ->
                      type = '|' + item.name.slice(item.name.lastIndexOf('.') + 1,item.name.lastIndexOf('.') + 4) + '|';
                      '|jpg|png|'.indexOf(type) !== -1
                });

                coreUploader.filters.push({
                    name: 'coreFilter',
                    fn: (item) ->
                      type = '|' + item.name.slice(item.name.lastIndexOf('.') + 1,item.name.lastIndexOf('.') + 4) + '|';
                      '|zip|rar|'.indexOf(type) !== -1
                });

            }

  }
