'use strict'

angular.module 'app.teacher'

.controller 'teacherTimer', ($scope, $interval, timerService) !->
  $scope.timerHide = true
  $scope.status-table = 
    'future':'未开始'
    'present': '进行中'
    'finish': '已结束'
  $scope.status-helper = (classes, status) ->
    for c in classes
      if c.status == status
        return true
    false
  timer = $interval (!->
    $scope.remain = timerService.calculateRemain $scope.class.startTime, $scope.class.endTime, $scope.class.status
    $scope.timerHide = false if $scope.remain.status == 'future'
    if $scope.class.status != $scope.remain.status
      $scope.class.status = $scope.remain.status
      $scope.class.t-status = $scope.status-table[$scope.remain.status]
      if $scope.status-helper $scope.homework.classes, 'present'
        $scope.homework.status = 'present'
        $scope.homework.t-status = '进行中'
      else
        if $scope.status-helper $scope.homework.classes, 'future'
          $scope.homework.status = 'future'
          $scope.homework.t-status = '未开始'
        else
          $scope.homework.status = 'finish'
          $scope.homework.t-status = '已结束'
    if $scope.remain.status == "finish" or $scope.remain.status == 'present' 
      $scope.timerHide = true
      $interval.cancel(timer)
    ), 1000




.config ($state-provider) !->
  $state-provider.state 'app.teacher.homework-list', {
    url: '/homework-list'
    # resolve: 都迁移到了homework-manager服务里面(teacher.ls文件中)
    views:
      'content@app':
        template-url: 'app/main/teacher/homework-list/homework-list.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, homework-manager, $state, $mdDialog)!->

          @user = Authentication.get-user!
          if @user.role is 'teacher'
            @greeting = @greeting + '老师'

          # 监听homeworks的更新事件
          $scope.$on 'homeworkUpdate', (ev)!~>
            @update-page homework-manager.homework-cache

          # 初始化获取所有homeworks的信息
          homework-manager.get-homeworks!
            .then (hws)!~>
              @update-page hws
       
          @update-page = (hws)!->
            @homeworks = hws


          @edit-homework = (hid) ->
            # $state.go 'app.teacher.edit-homework', {hid : hid}
            $mdDialog.show {
              templateUrl: 'app/main/teacher/homework-list/edit-homework.html'
              controller-as: '_vm'
              resolve: 
                homework: (homework-manager) ->
                  homework-manager.find-homework-by-hid hid

              parent: angular.element(document.body)
              clickOutsideToClose: false
              controller: ($scope, $mdDialog, homework-manager, homework) !->
                @hw = {}
                # homework-manager.find-homework-by-hid hid
                #   .then (homework) !~>
                
                @classes = [] # homework.classes的副本,防止homework-list中时间随未提交的表格变化
                for from 0 to homework.classes.length - 1
                  @classes[i$] = {}
                  for k, v of homework.classes[i$]
                    @classes[i$][k] = v

                @classIds = []
                @date-invalid = []

                @id = homework.id
                @title = homework.title
                @description = homework.description
                # 当前编辑的班级班号
                @classShowId = @classes[0].class_id

                @start-hour = []
                @start-min = []
                @end-hour = []
                @end-min = []

                # 选择框 options, 根据班号编辑
                # datepicker只接受Date类型值，故将日期转换成Date类型（datepicker在这里并不好用，可考虑用 md-select 选择日期）
                for from 0 to @classes.length - 1
                  @classIds[i$] = @classes[i$].class_id
                  @classes[i$].start-time = new Date(@classes[i$].start-time)
                  @classes[i$].end-time = new Date(@classes[i$].end-time)
                  @start-hour[i$] = @classes[i$].start-time.get-hours!
                  @start-min[i$] = @classes[i$].start-time.get-minutes!
                  @end-hour[i$] = @classes[i$].end-time.get-hours!
                  @end-min[i$] = @classes[i$].end-time.get-minutes!
                  @date-invalid[i$] = false

                #select元素options初始化
                @hours = []
                @mins = []          
                for from 0 to 59
                  @mins[i$] = i$
                  if i$ < 24
                    @hours[i$] = i$

                @hw = homework

                # 创建弹窗提示
                @create-alert = (condition)->
                  text = condition + '作业成功'
                  alert = $mdDialog.alert!
                    .clickOutsideToClose true
                    .title '提示'
                    .ariaLabel 'Alert Dialog'
                    .ok '知道了!'
                    .textContent text

                $scope.cancel = !->
                  $mdDialog.hide!

                # 删除作业按钮点击事件
                $scope.delete-homework= (ev)!~>
                  confirm = $md-dialog.confirm!
                    .title '删除确认'
                    .textContent '您确认删除该作业 \"' + @title + '\" 吗？注意删除后不可恢复!'
                    .targetEvent ev
                    .ok '确定'
                    .cancel '取消'
                  $md-dialog.show confirm
                    # console.warn 'test for develope'
                    .then ~> @id
                    .then homework-manager.delete-homework
                    .then !~>
                      alert = @create-alert '删除'
                      $md-dialog.show alert

                # 编辑确认按钮点击事件
                $scope.edit-homework = !~>
                  # 判断日期是否合法
                  @invalid-id = 0

                  # 将select元素的时、分存入@classes中；
                  # 判断日期是否合法，并将Date类型的start-time/end-time转换成ISOString类型
                  for from 0 to @classes.length - 1
                    @parse-date @classes[i$], i$

                  # 合法，向后台发送请求，更新数据@hw
                  if @invalid-id == 0
                    @hw.id = @id
                    @hw.title = @title
                    @hw.description = @description 
                    # console.warn 'test for develope'
                    homework-manager.update-homework hid, @hw
                      .then !~>
                        alert = @create-alert '编辑'
                        $md-dialog.show alert
                        $mdDialog.hide!

                @parse-date = (c, i) !->
                  c.start-time.set-hours @start-hour[i], @start-min[i]
                  c.end-time.set-hours @end-hour[i], @end-min[i]
                  if @date-validator c, i
                    @hw.classes[i].start-time = c.start-time.toISOString!
                    @hw.classes[i].end-time = c.end-time.toISOString!

                # 开始时间不能大于结束时间
                @date-validator = (c, i) ->
                  @date-invalid[i] = false
                  if c.start-time >= c.end-time
                    @date-invalid[i] = true
                    @invalid-id = c.class_id
                  !@date-invalid[i]
            }

          @review-homework = (hid) ->
            $state.go 'app.teacher.review-homework', {id : hid}
  }
