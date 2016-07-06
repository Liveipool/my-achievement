'use strict'

angular.module 'app.homework'

.config ($state-provider) !->
  $state-provider.state 'app.homework.dashboard', {
    url: '/homework/dashboard'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data.homeworks
            Promise.resolve homeworks
    views:
      'content@app':
        template-url: 'app/main/homework/dashboard/homework-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks)!->
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
  }