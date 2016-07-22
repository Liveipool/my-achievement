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
          vm.scores = arr2string homework-detail.scores
          vm.homework-ids = arr2string homework-detail.homework-ids
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

          vm.tickFormat = (d)!->
            if (d == 0)
              return 1
            else
              return d

          $scope.jump = (description)!->
            #TODO 实际中改为作业链接
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

                pictureUploader.onSuccessItem = (fileItem, response, status, headers) !->
                  $scope.pictureUploadState = true

                coreUploader.onSuccessItem = (fileItem, response, status, headers) !->
                  $scope.coreUploadState = true

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
