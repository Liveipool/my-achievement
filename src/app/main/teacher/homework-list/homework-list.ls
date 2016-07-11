'use strict'

angular.module 'app.teacher'

.config ($state-provider,  ms-navigation-service-provider) !->
  $state-provider.state 'app.teacher.homework-list', {
    url: '/homework/list'
    resolve:
      homeworks: ($resource) ->
        $resource('app/data/homework/homeworks.json').get!.$promise
          .then (result)->
            homeworks = result.data
            Promise.resolve homeworks
    views:
      'content@app':
        template-url: 'app/main/teacher/homework-list/homework-list.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homeworks, $state)!->

          console.log "欢迎回来!"
          @user = Authentication.get-user!
          @greeting  = @user.fullname;
          if @user.role is 'teacher'
            @greeting = @greeting + '老师'


          @edit-homework = (hid) ->
            $state.go 'app.teacher.edit-homework', {id : hid}
          @review-homework = (hid) ->
            $state.go 'app.teacher.review-homework', {id : hid}


          @status-helper = (classes, status) ->
            for c in classes
              if c.status == status
                return true
            false
          @calculate-status = (hs) !->
            for h in hs
              if @status-helper h.classes, 'current'
                h.status = 'current'
                h.t-status = '进行中'
              else
                if @status-helper h.classes, 'future'
                  h.status = 'future'
                  h.t-status = '未开始'
                else
                  h.status = 'finish'
                  h.t-status = '已结束'
            for h in hs
              h.bg = 'image-div-' + (1 + parse-int 12 * Math.random!)
              for c in h.classes
                c.t-status = '进行中' if c.status == 'current'
                c.t-status = '未开始' if c.status == 'future'
                c.t-status = '已结束' if c.status == 'finish'

          @homeworks = homeworks
          @calculate-status @homeworks

  }
