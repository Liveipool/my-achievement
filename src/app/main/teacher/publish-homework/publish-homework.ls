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
                self = @
                console.log @hw-obj

                # header
                @user = Authentication.get-user!
                @greeting  = @user.fullname

                # hw-card header
                @hw-num = homeworks.length
                @current-hw-num = @hw-num + 1

                @class-num = homeworks[0].classes.length

                @class-detail = []
                for from 0 to @class-num - 1
                  @class-detail.push {
                    class-id: i$ + 1
                    start-time: ""
                    end-time: ""
                    status: "present"
                  }
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
                @date-empty = []
                for from 0 to @class-num - 1
                  @date-invalid[i$] = @date-empty[i$] = false
                  @start-hour[i$] =  0
                  @start-min[i$] = 0
                  @end-hour[i$] =  0
                  @end-min[i$] = 0

                # 从页面获取的数据
                @hw-obj =
                  id: @current-hw-num
                  title: "第"+ @current-hw-num + "次作业"
                  description: ""
                  class-detail: @class-detail

                @classes = @hw-obj.class-detail

                # 注：数据未保存
                @Submit = !->
                   console.log 'Submit'
                   if self.validator!
                      $state.go 'app.teacher.homework.list'
                   console.log "new-obj: ", self.hw-obj # hw-obj：待插入的数据

                @Reset = !->
                  console.log 'Reset'
                  self.hw-obj.hw-title = ''
                  self.hw-obj.hw-url = ''
                  for each-class in self.hw-obj.class-detail
                    for k of each-class
                      if k != 'classStatus' && k != 'classId'
                        each-class[k] = ""
                  console.log self.hw-obj

                @parse-class-detail = (class-detail) !->
                  for item in class-detail
                    console.log item.start-time
                    item.start-time.set-hours self.start-hour[i$]
                    item.start-time.set-minutes self.start-min[i$]
                    item.end-time.set-hours self.end-hour[i$]
                    item.end-time.set-minutes self.end-min[i$]

                @validator = ->
                  valid = true
                  for item in self.hw-obj.class-detail
                    if item.start-time == "" || item.end-time == ""
                      self.date-empty[i$] = true
                      valid = false
                    else
                      self.date-empty[i$] = false
                      self.parse-class-detail self.hw-obj.class-detail
                      if item.start-time >= item.end-time
                        self.date-invalid[i$] = true
                        console.log "data invalid: ", i$
                        valid = false
                      else self.date-invalid[i$] = false
                  valid
    }