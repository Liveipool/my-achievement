'use strict'

angular.module 'app.student'

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
            options:
              chart:
                type                   : 'lineChart'
                color                  : ['#2196F3']
                isArea                 : true
                useInteractiveGuideline: true
                # duration               : 1
                clipEdge               : true
                clipVoronoi            : false
                interpolate            : 'cardinal'
                showLegend             : false
                height: 415px
                x: (d)->
                  d.x
                y: (d)->
                  d.y
                xAxis:
                  showMaxMin: true
                  min: 0
                  tickFormat: (d)!->
                    # date = new Date(new Date().setDate(new Date().getDate() + d))
                    return "作业" + d
                yAxis:
                  axisLabel: 'Y Axis'
            data: [{
              values:
                * "x": 1
                  "y": 65
                * "x": 2
                  "y": 57
                * "x": 3
                  "y": 80
                * "x": 4
                  "y": 94
                * "x": 5
                  "y": 78
                * "x": 6
                  "y": 65
                * "x": 7
                  "y": 97
              key: 'score'
            }]

          # @scoreChart =
          #   labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July']
          #   series: ['Score']
          #   data  : [
          #       [65, 59, 80, 81, 56, 55, 40]
          #   ]
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
