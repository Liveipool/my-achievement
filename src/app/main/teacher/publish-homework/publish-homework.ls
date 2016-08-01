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
              controller: ($state, Authentication, Interaction, homework-manager, $scope)!->
                # header
                @user = Authentication.get-user!
                @greeting  = @user.fullname + "老师"
                @location = "发布作业"
                @theme = Interaction.get-bg-by-month 2

                homework-manager.get-current-id-num!
                  .then (result)!~>
                    @hw-id = result.id
                    @class-num = result.num

                    # console.log @hw-id
                    # console.log @class-num

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

                    $scope.init-time= !~>
                      for from 0 to @class-num - 1
                        @date-invalid[i$] = false
                        @start-hour[i$] = 0
                        @start-min[i$] = 0
                        @end-hour[i$] = 0
                        @end-min[i$] = 0
                    $scope.init-time!

                    # 从页面获取的数据
                    @hw-obj =
                      id: @hw-id
                      title: ""
                      description: ""
                      classes: @class-detail

                    # console.log @hw-obj

                @Submit = !->
                   # console.log 'Submit'
                   # console.log "new-obj: ", @hw-obj
                   if @validator!
                      homework-manager.insert-homework @hw-obj
                        .then !->
                        $state.go 'app.teacher.homework-list'

                @Reset = !~>
                  # console.log 'Reset'
                  @hw-obj.title = '作业'+ @hw-obj.id +':'
                  @hw-obj.description = ''
                  for each-class in @hw-obj.classes
                    for k of each-class
                      if k != 'status' && k != 'classId'
                        each-class[k] = ""
                  $scope.init-time!
                  # console.log @hw-obj

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
                        # console.log "data invalid: ", i$
                        valid = false
                      else @date-invalid[i$] = false
                  valid
    }