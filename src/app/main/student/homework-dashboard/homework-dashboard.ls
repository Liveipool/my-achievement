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
    data:
      role: 'student'

    views:
      'content@app':
        template-url: 'app/main/student/homework-dashboard/homework-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks, $mdDialog, Interaction)!->
          console.log "欢迎回来!"
          vm = @
          vm.user = Authentication.get-user!
          console.log vm.user
          vm.location = "作业列表"
          vm.theme = Interaction.get-bg-by-month 2

          vm.greeting  = vm.user.fullname;

          vm.homeworks = homeworks

          for homework in vm.homeworks
            _.remove homework.classes, (c) -> c.class_id isnt vm.user.class


          vm.status =
            future: "未开始"
            present: "进行中"
            finish: "已结束"

          vm.fg =
            future: "light-blue-fg"
            present: "red-fg"
            finish: "grey-fg"

          vm.bg =
            future: "light-blue-bg"
            present: "red-bg"
            finish: "grey-bg"

          vm.switch =
            future: true
            present: true
            finish: true

          scoreChart = c3.generate {
            bindto: '#scoreChart'
            data:
              columns: [
                ['score', 95, 59, 100, 88, 90, 60, 94, 90, 90, 95]
              ]
              colors:
                score: '#19b0f5'
            grid:
              x:
                show: false
              y:
                show: true
            axis:
              x:
                type: 'category'
                categories: ['作业1', '作业2', '作业3', '作业4', '作业5', '作业6', '作业7', '作业8', '作业9', '作业10']
          }

          rankChart = c3.generate {
            bindto: '#rankChart'
            data:
              columns: [
                ['rank', 30, 200, 100, 20, 150, 150, 50, 100, 70, 1]
              ]
              colors:
                rank: '#ffb300'
            grid:
              x:
                show: false
              y:
                show: true
            axis:
              x:
                type: 'category'
                categories: ['作业1', '作业2', '作业3', '作业4', '作业5', '作业6', '作业7', '作业8', '作业9', '作业10']
              y:
                tick:
                  values: [1, 30, 60, 90, 120, 150, 180, 210]
                inverted: true
          }

          $scope.jump = (description)!->
            window.open "http://www.baidu.com"

          

          $scope.showSubmitDialog = (id)!->
            $mdDialog.show {
              templateUrl: 'app/main/student/homework-dashboard/submitDialog.html',
              parent: angular.element(document.body),
              clickOutsideToClose: false,
              controller: ($scope, $mdDialog, FileUploader, $interval) !->
                $scope.determinateValue = 30
                $scope.id = id
                $scope.showProgress = false

                $interval !->
                  $scope.determinateValue += 1
                  if ($scope.determinateValue > 100)
                    $scope.determinateValue = 30
                ,100, 0, true
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
                  $scope.showProgress = true
                  pictureUploader.uploadAll();
                  coreUploader.uploadAll();
                  
            }

  }
