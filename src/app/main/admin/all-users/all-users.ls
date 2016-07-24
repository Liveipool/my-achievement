'use strict'

angular.module 'app.admin'

.config ($state-provider) !->
  $state-provider.state 'app.admin.all-users', {
    url: '/all-users'
    # resolve: 都迁移到了user-manager-service服务里面(admin.ls文件中)
    views:
      'content@app':
        template-url: 'app/main/admin/all-users/all-users.html'
        controller-as : 'vm'
        controller: ($scope, $md-dialog, $md-media, valid-manager-service, user-manager-service, Interaction)!->

          @theme = Interaction.get-bg-by-month 2
          @location = "所有用户"
          @greeting = "管理员"

          # 监听窗口大小事件改变表格展示高度
          height-watch = ->
            window.inner-height
          height-change-process = (value)!->
            $scope.widget-height = value - 300
          $scope.$watch height-watch, height-change-process

          # 监听users的更新事件
          $scope.$on 'usersUpdate', (ev)!->
            $scope.update-tables user-manager-service.users-cache

          # table头的展示信息
          $scope.ad-columns = $scope.tea-columns = $scope.ta-columns = ['用户名','姓名', '邮箱', '编辑']
          $scope.stu-columns = ['学号', '姓名', '班级', '组别', '编辑']
          $scope.stu-columns-by-class = ['学号', '姓名', '组别', '编辑']

          # 初始化获取所有users的信息之后更新表格信息
          user-manager-service.get-users!.then (users)!->
            $scope.update-tables users

          $scope.update-tables = (users)!->
            $scope.admin = []
            $scope.teachers = []
            $scope.TAs = []
            $scope.students = []

            # 根据role分开用户
            for i from 0 to users.length - 1 by 1
              switch users[i].role
                case "admin"
                  $scope.admin.push users[i]
                case "teacher"
                  $scope.teachers.push users[i]
                case "ta"
                  $scope.TAs.push users[i]
                case "student"
                  $scope.students.push users[i]

            # 根据班别分开学生
            $scope.students.sort (a, b)->
              priority = a.class.locale-compare b.class
              if priority ~= 0
                a.group.locale-compare b.group
              else
                priority

            $scope.classes = []
            for i from 0 to $scope.students.length - 1 by 1
              if ($scope.classes.length ~= 0 or $scope.classes[$scope.classes.length - 1].class-name !~= $scope.students[i].class)
                $scope.classes.push {
                  class-name: $scope.students[i].class
                  students: []
                }
              $scope.classes[$scope.classes.length - 1].students.push $scope.students[i]

          # 展示编辑框
          $scope.showAdvanced = (ev) ->
              use-full-screen = ($md-media 'sm' || $md-media 'xs')  && $scope.customFullscreen;
              $md-dialog.show {
                # 编辑页面控制器
                controller: ($scope, $md-dialog, $md-toast, user-manager-service)!->
                  $scope.hide = !-> $md-dialog.hide!
                  $scope.cancel = !-> $md-dialog.cancel!

                  user-manager-service.find-user-by-username ev.current-target.attributes["username"].value
                    .then (user)!->
                      $scope.user = user

                  $scope.edit-user = !->
                    $scope.user ||= {}
                    invalid-arr = valid-manager-service.edit-user-valid $scope.user
                    if invalid-arr.length ~= 0
                      # 发送修改请求
                      user-manager-service.edit-user $scope.user
                    else
                      $md-toast.show(
                        $md-toast.simple!
                          .textContent invalid-arr.join(',') + '不合法，请仔细查看!'
                          .action 'OK'
                          .highlightAction true
                          .highlightClass 'md-warn'
                          .position 'top right'
                          .hide-delay 5000
                      )

                  $scope.delete-user = (ev)!->
                    $scope.user ||= {}
                    confirm = $md-dialog.confirm!
                      .title '删除确认'
                      .textContent '您确认删除该用户 \"' + $scope.user.username + '\" 吗？注意删除后不可恢复!'
                      .targetEvent ev
                      .ok '确定'
                      .cancel '取消'
                    $md-dialog.show confirm .then !->
                      # 发送删除请求
                      user-manager-service.delete-user $scope.user.username

                templateUrl: 'app/main/admin/all-users/admin-user-edit.html'
                parent: angular.element(document.body)
                targetEvent: ev
                clickOutsideToClose:true
                fullscreen: use-full-screen
              }
  }
