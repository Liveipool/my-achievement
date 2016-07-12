'use strict'

angular.module 'app.student'

.config ($state-provider) !->
  $state-provider.state 'app.student.homework-dashboard', {
    url: '/homework-dashboard'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data
            Promise.resolve homeworks


    views:
      'content@app':
        template-url: 'app/main/student/homework-dashboard/homework-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks, $mdDialog)!->
          console.log "欢迎回来!"
          vm = @
          vm.user = Authentication.get-user!

          vm.greeting  = vm.user.fullname;

          vm.homeworks = homeworks

          for homework in vm.homeworks
            _.remove homework.classes, (c) -> c.class_id isnt vm.user.class


          vm.status =
            future: "未开始"
            present: "进行中"
            finish: "已结束"

          vm.fg =
            future: "orange-fg"
            present: "red-fg"
            finish: "light-blue-fg"

          vm.switch =
            future: true
            present: true
            finish: true

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
