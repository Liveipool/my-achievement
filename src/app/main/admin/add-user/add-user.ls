'use strict'

angular.module 'app.admin'

.config ($state-provider) !->
  $state-provider.state 'app.admin.add-user', {
    url: '/add-user'
    views:
      'content@app':
        template-url: 'app/main/admin/add-user/add-user.html'
        controller-as : 'vm'
        controller: ($scope, valid-manager-service, $md-toast, user-manager-service, Interaction, FileUploader)!->
          @greeting = "管理员"
          $scope.show-upload-progress = false

          $scope.add-user = !->
            $scope.user ||= {}
            invalid-arr = valid-manager-service.add-user-valid $scope.user
            if invalid-arr.length ~= 0
              # 发送新增请求
              user-manager-service.add-user $scope.user
            else
              $md-toast.show(
                $md-toast.simple!
                  .textContent invalid-arr.join(',') + '不合法，请仔细查看！'
                  .action 'OK'
                  .highlightAction true
                  .highlightClass 'md-warn'
                  .position 'top right'
                  .hide-delay 5000
              )

          $scope.reset-user = !->
            $scope.user = {}
            # console.log "queue.length", $scope.json-uploader.queue.length

          # 上传文件批量添加用户
          $scope.json-uploader = new FileUploader {
            url: "http://localhost:3000/upload-jsons"
            alias: "upload-jsons"
            queueLimit: 1
            # autoUpload: true
            removeAfterUpload: true
          }

          # $scope.json-uploader.onWhenAddingFileFailed = (item) !->
          #   console.log 'onWhenAddingFileFailed: ', item
          $scope.json-uploader.onAfterAddingFile = (item) !->
            $scope.json-uploader.uploadItem item
            $scope.show-upload-progress = true
            console.log 'onAfterAddingFile: ', item
          # $scope.json-uploader.onBeforeUploadItem = (item) !->
          #   console.log 'onBeforeUploadItem: ', item
          # $scope.json-uploader.onSuccessItem = (item) !->
          #   console.log 'onSuccessItem'
          # $scope.json-uploader.onCompleteItem = (item) !->
          #   console.log 'onCompleteItem'
          # $scope.json-uploader.onErrorItem = (item) !->
          #   console.log 'onErrorItem'
          # $scope.json-uploader.onCancelItem = (item) !->
          #   console.log 'onCancelItem'

          $scope.clear-json-item = !->
            $scope.json-uploader.clearQueue!

          $scope.json-uploader.filters.push({
            name: 'jsonFilter'
            fn: (item) ->
              type = '|' + item.name.slice(item.name.lastIndexOf('.') + 1,item.name.lastIndexOf('.') + 5) + '|';
              '|json|'.indexOf(type) !== -1
          })
          $scope.json-uploader.filters.push({
            name: 'jsonSizeFilter'
            fn: (item) ->
              # console.log 'item.size: ', item.size
              item.size <= 50000
          })
  }
