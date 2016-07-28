'use strict'

angular.module 'app.teacher'

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider) !->
    'ngInject'

    $state-provider.state 'app.teacher.publish-homework', {
        url: '/publish-homework'
        # resolve: 都迁移到了homework-manager服务里面(teacher.ls文件中)
        views:
            'content@app':
              template-url: 'app/main/teacher/publish-homework/publish-homework.html'
              controller-as: 'vm'

              controller: ($state, Authentication, Interaction, homework-manager)!->
                # header
                @user = Authentication.get-user!
                @greeting  = @user.fullname + "老师"
                @location = "发布作业"
                @theme = Interaction.get-bg-by-month 2

                # hw-card header
                # TODO
                @current-hw-num = homework-manager.get-current-id!

                @class-num = homework-manager.get-class-num!
                console.log @current-hw-num
                console.log @class-num

                @class-detail = []
                for from 0 to @class-num - 1
                  @class-detail.push {
                    class_id: i$ + 1
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
                  classes: @class-detail

                console.log @hw-obj

                # 注：数据未保存
                @Submit = !->
                   console.log 'Submit'
                   console.log "new-obj: ", @hw-obj # TODO：待插入的数据
                   if @validator!
                      homework-manager.insert-homework @hw-obj
                        .then !->
                        $state.go 'app.teacher.homework-list'

                @Reset = !~>
                  console.log 'Reset'
                  @hw-obj.title = ''
                  @hw-obj.description = ''
                  for each-class in @hw-obj.classes
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
                  for item in @hw-obj.classes
                      @parse-class-detail @hw-obj.classes
                      if item.start-time >= item.end-time
                        @date-invalid[i$] = true
                        console.log "data invalid: ", i$
                        valid = false
                      else @date-invalid[i$] = false
                  valid
    }