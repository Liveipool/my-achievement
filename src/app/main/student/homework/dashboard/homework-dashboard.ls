'use strict'

angular.module 'app.student'

.config ($state-provider) !->
  $state-provider.state 'app.student.homework.dashboard', {
    url: '/homework/dashboard'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data
            Promise.resolve homeworks
    data:
      role: 'student'

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
          console.log @homeworks
          @status =
            future: "未开始"
            present: "进行中"
            finish: "已结束"
          @fg =
            future: "light-blue-fg"
            present: "red-fg"
            finish: "blue-grey-fg"

          $scope.showSubmitDialog = (id)!->
            $mdDialog.show {
              templateUrl: 'app/main/student/homework/dashboard/submitDialog.html',
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
