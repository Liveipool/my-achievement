'use strict'

angular.module 'app.teacher'

.config ($state-provider) !->
  $state-provider.state 'app.teacher.homework-list', {
    url: '/homework-list'
    # resolve: 都迁移到了homework-manager服务里面(teacher.ls文件中)
    views:
      'content@app':
        template-url: 'app/main/teacher/homework-list/homework-list.html'
        controller-as : 'vm'
        controller: ($scope, Authentication, $state, Interaction, $mdDialog, homework-manager)!->

          @user = Authentication.get-user!
          @location = "所有作业"
          @theme = Interaction.get-bg-by-month 2
          @greeting  = @user.fullname;  
          if @user.role is 'teacher'
            @greeting = @greeting + '老师'

          @review-homework = (hid) ->
            # TODO: 或可以复用TA评审页面
            
          @status-helper = (classes, status) ->
            for c in classes
              if c.status == status
                return true
            false

          @calculate-status = (hs) !~>
            for h in hs
              if @status-helper h.classes, 'present'
                h.status = 'present'  
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
               # 对于不以"https://"或"http://"开头的，加上"http://"
              unless /http/.test h.description
                  unless /https/.test h.description
                      h.description = 'http://' + h.description

              for c in h.classes
                c.t-status = '进行中' if c.status == 'present'
                c.t-status = '未开始' if c.status == 'future'
                c.t-status = '已结束' if c.status == 'finish'

          # 监听homeworks的更新事件
          $scope.$on 'homeworkUpdate', (ev)!~>
            console.log 'update'
            @update-page homework-manager.homework-cache

          # 初始化获取所有homeworks的信息
          homework-manager.get-homeworks!
            .then (hws)!~>
              @update-page hws
       
          @update-page = (hws)!->
            @homeworks = hws
            @calculate-status hws

          # 编辑作业窗口
          @edit-homework = (hid) ->
            $mdDialog.show {
              templateUrl: 'app/main/teacher/homework-list/edit-homework.html'
              controller-as: '_vm'
              parent: angular.element(document.body)
              clickOutsideToClose: false
              controller: ($scope, $mdDialog, homework-manager) !->
                @hw = {}
                homework-manager.find-homework-by-hid hid
                  .then (homework) !~>

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
                    .then ~> @id
                    .then homework-manager.delete-homework
                    .then !~>
                      alert = @create-alert '删除'
                      $md-dialog.show alert

                # 编辑确认按钮点击事件
                $scope.edit-homework = !~>
                  # 判断日期是否合法
                  @valid = true

                  # 将select元素的时、分存入@classes中；
                  # 判断日期是否合法，并将Date类型的start-time/end-time转换成ISOString类型
                  for from 0 to @classes.length - 1
                    @parse-date @classes[i$], i$

                  # 合法，向后台发送请求，更新数据@hw
                  if @valid
                    @hw.id = @id
                    @hw.title = @title
                    @hw.description = @description 

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
                  else 
                    @valid = false

                # 开始时间不能大于结束时间
                @date-validator = (c, i) ->
                  @date-invalid[i] = false
                  if c.start-time >= c.end-time
                    @date-invalid[i] = true
                  !@date-invalid[i]
            }
  }
