'use strict'

angular.module 'app.admin'

.config ($state-provider) !->
  $state-provider.state 'app.admin.add-user', {
    url: '/add-user'
    views:
      'content@app':
        template-url: 'app/main/admin/add-user/add-user.html'
        controller-as : 'vm'
        controller: ($scope, valid-manager, $md-toast, user-manager, Interaction)!->
          @theme = Interaction.get-bg-by-month 2
          @location = "添加用户"
          @greeting = "管理员"

          $scope.add-user = !->
            $scope.user ||= {}
            invalid-arr = valid-manager.add-user-valid $scope.user
            if invalid-arr.length ~= 0
              # 发送新增请求
              user-manager.add-user $scope.user
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

          # TODO: 文件上传函数实现

  }