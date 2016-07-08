'use strict'

angular.module 'app.admin'

.config ($state-provider) !->
  $state-provider.state 'app.admin.users', {
    url: '/admin/all-users'
    resolve:
      users: ($resource) ->
        $resource('app/data/admin/users.json').get!.$promise
          .then (result)->
            users = result.data.users
            Promise.resolve users
    views:
      'content@app':
        template-url: 'app/main/admin/users/admin-users.html'
        controller-as : 'vm'
        controller: ($scope, users, $md-dialog, $md-media)!->
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

          $scope.ad-columns = $scope.tea-columns = $scope.ta-columns = ['用户名','姓名', '邮箱', '编辑']
          $scope.stu-columns = ['学号', '姓名', '用户名', '班级', '组别', '编辑']
          $scope.stu-columns-by-class = ['学号', '姓名', '用户名', '组别', '编辑']

          # 根据班别分开学生
          $scope.students.sort (a, b)->
            a.class.locale-compare b.class

          $scope.classes = []
          for i from 0 to $scope.students.length - 1 by 1
            if ($scope.classes.length ~= 0 or $scope.classes[$scope.classes.length - 1].class-name !~= $scope.students[i].class)
              $scope.classes.push {
                class-name: $scope.students[i].class
                students: []
              }
            $scope.classes[$scope.classes.length - 1].students.push $scope.students[i]
          
          # 寻找user
          find-user-by-username = (username)->
            user = {}
            for i from 0 to users.length - 1 by 1
              if users[i].username ~= username
                user = users[i]
                break
            user
          # 判断表单是否合法
          valid = (user)->
            user.fullname !~= "" and /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test user.email
          
          # 展示编辑框
          $scope.showAdvanced = (ev) ->
              use-full-screen = ($md-media 'sm' || $md-media 'xs')  && $scope.customFullscreen;
              $md-dialog.show {
                # 编辑页面控制器
                controller: ($scope, $md-dialog, $mdToast)!->
                  $scope.user = ^^find-user-by-username ev.current-target.attributes["username"].value
                  $scope.hide = !-> $md-dialog.hide!
                  $scope.cancel = !-> $md-dialog.cancel!
                  $scope.answer = (answer)!-> $md-dialog.hide answer
                  $scope.edit-user = !-> 
                    if valid $scope.user
                      # 发送修改请求
                      console.log $scope.user
                    else
                      $mdToast.show(
                        $mdToast.simple!
                          .textContent '输入表单不合法!'
                          .action 'OK'
                          .highlightAction true
                          .highlightClass 'md-warn'
                          .position 'top right'
                          .hide-delay 5000
                      )
                  $scope.delete-user = !->
                    # 发送删除请求
                    console.log $scope.user.username

                templateUrl: 'app/main/admin/users/admin-user-edit.html'
                parent: angular.element(document.body)
                targetEvent: ev
                clickOutsideToClose:true
                fullscreen: use-full-screen
              }
  }