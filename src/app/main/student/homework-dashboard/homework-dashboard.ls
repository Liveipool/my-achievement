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
      homeworks: (homework-detail-service) ->
        homework-detail-service.getHomeworks!


      homework-detail: (Authentication, homework-detail-service) !->
        user = Authentication.get-user!
        return homework-detail-service.getScoresAndHomeworkIds user .then (result) !->
          IS = result
          return homework-detail-service.getRanksAndAverScores IS.scores, IS.homeworkIds .then (result) ->
            AR = result
            Promise.resolve {IS: IS, AR: AR}     # IS: homework-ids and scores, AR: average scores and ranks

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
          vm.IS = homework-detail.IS
          vm.homework-ids = arr2string vm.IS.homeworkIds
          vm.stringScores = arr2string vm.IS.scores
          vm.AR = homework-detail.AR
          vm.stringRanks = arr2string vm.AR.ranks


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
              controller: ($scope, $mdDialog, FileUploader, $interval, $http) !->
                $scope.id = id
                $scope.githubAddress = ""
                $scope.showProgress = false

                $scope.cancel = !->
                  $mdDialog.hide!

                homeworkPictureUploader = $scope.homeworkPictureUploader = new FileUploader {
                  url: 'http://localhost:3000/upload-homework-pictures'
                  alias: 'upload-homework-pictures'
                  queueLimit: 1
                  removeAfterUpload: false
                  form-data: [{"homework_id": $scope.id}]
                }

                homeworkCodeUploader = $scope.homeworkCodeUploader = new FileUploader {
                  url: 'http://localhost:3000/upload-homework-codes'
                  alias: 'upload-homework-codes'
                  queueLimit: 1,
                  removeAfterUpload: false
                  form-data: [{"homework_id": $scope.id}]
                }

                $scope.clearHomeworkPictureItem = !->
                  homeworkPictureUploader.clearQueue!

                $scope.clearHomeworkCodeItem = !->
                  homeworkCodeUploader.clearQueue!

                homeworkPictureUploader.onAfterAddingFile = (fileItem) !->
                  $scope.homeworkPicture = fileItem._file

                homeworkCodeUploader.onAfterAddingFile = (fileItem) !->
                  $scope.homeworkCode = fileItem._file

                $scope.uploadFile = !->
                  $scope.showProgress = true
                  homeworkPictureUploader.uploadAll!
                  homeworkCodeUploader.uploadAll!
                  # console.log "githubAddress: ", $scope.githubAddress
                  # if $scope.githubAddress
                  #   homeworkCommitService.edit-commit(id) #这个service还没写好

                homeworkPictureUploader.filters.push({
                    name: 'homeworkPictureTypeFilter',
                    fn: (item) ->
                      type = '|' + item.name.slice(item.name.lastIndexOf('.') + 1,item.name.lastIndexOf('.') + 4) + '|';
                      '|jpg|png|'.indexOf(type) !== -1
                });

                homeworkCodeUploader.filters.push({
                    name: 'homeworkCodeTypeFilter',
                    fn: (item) ->
                      type = '|' + item.name.slice(item.name.lastIndexOf('.') + 1,item.name.lastIndexOf('.') + 4) + '|';
                      '|zip|rar|'.indexOf(type) !== -1
                });

                homeworkPictureUploader.filters.push({
                  name: 'homeworkPictureSizeFilter'
                  fn: (item) ->
                    item.size <= 1000000
                })

                homeworkCodeUploader.filters.push({
                  name: 'homeworkCodeSizeFilter'
                  fn: (item) ->
                    item.size <= 50000000  # 暂时设定50MB
                })
                   
            }

  }

