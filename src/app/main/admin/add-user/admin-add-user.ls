'use strict'

angular.module 'app.admin'

.config ($state-provider) !->
  $state-provider.state 'app.admin.add-user', {
    url: '/admin/add-user'
    views:
      'content@app':
        template-url: 'app/main/admin/add-user/admin-add-user.html'
        controller-as : 'vm'
        controller: ($scope, valid-manager, $md-toast, user-manager)!->

          $scope.add-user = !-> 
            $scope.user ||= {}
            if valid-manager.add-user-valid $scope.user
              # 发送新增请求
              user-manager.add-user $scope.user
            else
              $md-toast.show(
                $md-toast.simple!
                  .textContent '输入表单不合法，请仔细查看！'
                  .action 'OK'
                  .highlightAction true
                  .highlightClass 'md-warn'
                  .position 'top right'
                  .hide-delay 5000
              )

          $scope.reset-user = !->
            $scope.user = {}

          # TODO: 文件上传函数实现

  }