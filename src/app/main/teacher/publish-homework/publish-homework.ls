'use strict'

angular.module 'app.teacher'

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider) !->
    'ngInject'

    $state-provider.state 'app.teacher.publish-homework', {
        url: '/publish-homework'
        resolve:
          homeworks: ($resource) ->
            $resource('app/data/homework/homeworks.json').get!.$promise
              .then (result)->
                homeworks = result.data
                Promise.resolve homeworks
        views:
            'content@app':
              template-url: 'app/main/teacher/publish-homework/publish-homework.html'
              controller-as: 'vm'

              controller: ($state, Authentication, homeworks)!->

                # header
                @user = Authentication.get-user!

                # hw-card header
                @current-hw-num = homeworks.length + 1

                @class-num = homeworks[0].classes.length

                @class-detail = []
                for from 0 to @class-num - 1
                  @class-detail.push {
                    class-id: i$ + 1
                    start-time: ""
                    end-time: ""
                    status: "present"
                  }
                @classes = @class-detail

                # datepicker
                @hours = []
                @mins = []
                @start-hour = []
                @start-min = []
                @end-hour = []
                @end-min = []

                # select框options
                for from 0 to 59
                  @mins[i$] = i$
                  if i$ < 24
                    @hours[i$] = i$

                # validator bools
                @date-invalid = []

                init-time = !~>
                  for from 0 to @class-num - 1
                    @date-invalid[i$] = false
                    @start-hour[i$] = 0
                    @start-min[i$] = 0
                    @end-hour[i$] = 0
                    @end-min[i$] = 0
                init-time!

                # 从页面获取的数据
                @hw-obj =
                  id: @current-hw-num
                  title: ""
                  description: ""
                  class-detail: @class-detail

                console.log @hw-obj

                # 注：数据未保存
                @Submit = !->
                   console.log 'Submit'
                   console.log "new-obj: ", @hw-obj # TODO：待插入的数据
                   if @validator!
                      $state.go 'app.teacher.homework-list'

                @Reset = !~>
                  console.log 'Reset'
                  @hw-obj.title = ''
                  @hw-obj.description = ''
                  for each-class in @hw-obj.class-detail
                    for k of each-class
                      if k != 'status' && k != 'classId'
                        each-class[k] = ""
                  init-time!
                  console.log @hw-obj

                @parse-class-detail = (class-detail) !->
                  for item in class-detail
                    item.start-time.set-hours @start-hour[i$]
                    item.start-time.set-minutes @start-min[i$]
                    item.end-time.set-hours @end-hour[i$]
                    item.end-time.set-minutes @end-min[i$]

                @validator = ->
                  valid = true
                  for item in @hw-obj.class-detail
                      @parse-class-detail @hw-obj.class-detail
                      if item.start-time >= item.end-time
                        @date-invalid[i$] = true
                        console.log "data invalid: ", i$
                        valid = false
                      else @date-invalid[i$] = false
                  valid
    }