'use strict'

angular.module 'app.student'

# .config (ChartJsProvider)!->
#     ChartJsProvider.setOptions {colors: ['#F44336', '#00ADF9', '#DCDCDC', '#46BFBD', '#FDB45C', '#949FB1', '#4D5360']}

.config ($state-provider) !->
  $state-provider.state 'app.student.homework.dashboard', {
    url: '/homework/dashboard'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data.homeworks
            Promise.resolve homeworks
    views:
      'content@app':
        template-url: 'app/main/student/homework/dashboard/homework-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks, $mdDialog)!->
          console.log "欢迎回来!"
          @user = Authentication.get-user!
          @greeting  = @user.fullname;
          if @user.role is 'teacher'
            @greeting = @greeting + '老师'

          @homeworks = homeworks
          @status =
            future: "未开始"
            present: "进行中"
            finish: "已结束"
          @fg =
            future: "light-blue-fg"
            present: "red-fg"
            finish: "blue-grey-fg"

          @scoreChart =
            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July']
            series: ['Score']
            data  : [
                [65, 59, 80, 81, 56, 55, 40]
            ]
          @rankChart =
            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July']
            series: ['Rank']
            data  : [
                [12, 48, 40, 19, 86, 27, 90]
            ]

          $scope.showSubmitDialog = (id)!->
            $mdDialog.show {
              templateUrl: 'app/main/student/homework/dashboard/submitDialog.html',
              parent: angular.element(document.body),
              clickOutsideToClose: true,
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
          # $scope.showSubmitDialog = ()!->
          #   $mdDialog.show {
          #     contentElement: '#submitDialog',
          #     parent: angular.element(document.body)
          #   }

          # $scope.cancel = !->
          #   $mdDialog.hide!


  }


# DialogController = ($scope, $mdDialog, homeworks)!->
#   console.log("hahaha")
#   $scope.cancel = !->
#     $mdDialog.hide!