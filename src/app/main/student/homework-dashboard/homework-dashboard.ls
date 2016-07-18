'use strict'

angular.module 'app.student'

.controller 'hwTimer', ($scope, $interval, timerService) !->
  timer = $interval (!->
    $scope.remain = timerService.calculateRemain $scope.homework.classes[0].startTime, $scope.homework.classes[0].endTime, $scope.homework.classes[0].status
    $scope.homework.classes[0].status = $scope.remain.status), 1000
  

.factory 'timerService', ->
  calculate = (start, end, status) ->
    nowTime = new Date!
    startTime = new Date start
    endTime = new Date end

    if nowTime < startTime
      status = 'future'
    else if nowTime < endTime
      status = 'present'
    else 
      status = 'finish'

    switch status
    case 'future' 
    then 
      iRemain = (startTime.getTime! - nowTime.getTime!)/1000
    case 'present'
      iRemain = (endTime.getTime! - nowTime.getTime!)/1000
    case 'finish'
      iRemain = 0

    remain = {}
    remain.days =  parseInt iRemain/86400
    iRemain %= 86400
    remain.hours = parseInt iRemain/3600
    iRemain %= 3600
    remain.mins = parseInt iRemain/60
    iRemain %= 60
    remain.secs = parseInt iRemain
    remain.status = status

    timeSum = 0
    for key, value of remain
      timeSum = timeSum + value
    if timeSum == 0 and status == 'future' then remain.status = 'present'
    if timeSum == 0 and status == 'present' then remain.status = 'finish'
      # body...
    remain 

  calculateRemain: (start, end, status)->
    calculate start, end, status





.config ($state-provider) !->
  $state-provider.state 'app.student.homework-dashboard', {
    url: '/homework-dashboard'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data
            Promise.resolve homeworks

      homework-detail: ($resource, Authentication) ->
        $resource 'app/data/review/reviews.json' .get!.$promise
        .then (result) ->
          user = Authentication.get-user!
          reviews = _.filter result.data, (review) -> review.reviewee.username == user.username && review.reviewer.role is 'teacher'
          scores = [review.score for review in reviews]
          homework-ids = [review.homework_id for review in reviews]

          Promise.resolve {scores: scores, homework-ids: homework-ids}

    data:
      role: 'student'

    views:
      'content@app':
        template-url: 'app/main/student/homework-dashboard/homework-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks, $mdDialog, Interaction, homework-detail)!->
          console.log "欢迎回来!"
          console.log homework-detail

          vm = @
          vm.user = Authentication.get-user!
          vm.scores = homework-detail.scores
          vm.homework-ids = homework-detail.homework-ids

          vm.location = "作业列表"
          vm.theme = Interaction.get-bg-by-month 2

          vm.greeting  = vm.user.fullname;

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

          $scope.jump = (description)!->
            window.open "http://www.baidu.com"

          $scope.showSubmitDialog = (id)!->
            $mdDialog.show {
              templateUrl: 'app/main/student/homework-dashboard/submitDialog.html',
              parent: angular.element(document.body),
              clickOutsideToClose: false,
              controller: ($scope, $mdDialog, FileUploader) !->
                $scope.id = id

                $scope.cancel = !->
                  $mdDialog.hide!

                $scope.pictureUploadState = $scope.coreUploadState = false

                pictureUploader = $scope.pictureUploader = new FileUploader {
                  url: 'upload.php',
                  queueLimit: 1,
                  removeAfterUpload: false
                }

                coreUploader = $scope.coreUploader = new FileUploader {
                  url: 'upload.php',
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

                pictureUploader.onSuccessItem = (fileItem, response, status, headers) !->
                  $scope.pictureUploadState = true

                coreUploader.onSuccessItem = (fileItem, response, status, headers) !->
                  $scope.coreUploadState = true

                $scope.uploadFile = !->
                  pictureUploader.uploadAll();
                  coreUploader.uploadAll();


            }

  }
