'use strict'

angular.module 'app.teacher', []

.config ($state-provider,  ms-navigation-service-provider) !->
  $state-provider.state 'app.teacher', {
    abstract: true
    data:
      role: 'teacher'
  }

.service 'homeworkManager', ($resource, $root-scope)!->
  # 增删查改操作
  Homework = $resource('http://localhost:3000/api/Homework/:id', null,
    { 
        'insert': { method : 'POST'},
        'delete': { method : 'DELETE'},
        'get': { method : 'GET'},
        'update': { method : 'PUT'}
    }); 
  
  # 重新获取数据、存入cache
  @reload-homeworks = ~>
    that = @
    $resource('http://localhost:3000/api/Homework').query!.$promise
      .then (result)->
        that.homework-cache = result
        # console.log result
        $root-scope.$broadcast 'homeworkUpdate' # 广播更新事件
        Promise.resolve that.homework-cache

  @get-homeworks = ~>
    if @homework-cache
      Promise.resolve @homework-cache
    else
      @reload-homeworks!

  @insert-homework = (hw)~>
    # 向服务器发出请求插入新作业
    $resource('http://localhost:3000/api/Homework').save(hw).$promise
      .then @reload-homeworks

  @delete-homework = (hid)~>
    # 向服务器发出请求删除作业
    Homework.delete({ id:hid }).$promise
      .then @reload-homeworks

  @get-homework-by-id = (hid)~>
    # 根据作业id向服务器发出请求获取作业
    Homework.get({ id: hid}).$promise

  @update-homework = (hid, hw)~>
    # 向服务器发出请求编辑作业
    Homework.update({ id:hid }, hw).$promise
      .then @reload-homeworks

  @find-homework-by-hid = (hid)~>
    @get-homeworks!.then (homeworks)->
      homework = {}
      for i from 0 to homeworks.length - 1 by 1
        if homeworks[i].id == hid
          homework = homeworks[i]
          break
      Promise.resolve homework

  # @get-homework-count = ~>
  #     $resource('http://localhost:3000/api/Homework/count').get!.$promise
  #       .then (count)->
  #         count

  @get-current-id = ~>
      @homework-cache[@homework-cache.length - 1].id + 1

  @get-class-num = ~>
    if @homework-cache
      @homework-cache[0].classes.length
    else 2

.directive 'urlValidator', ->
    # 参考http://stackoverflow.com/questions/161738/what-is-the-best-regular-expression-to-check-if-a-string-is-a-valid-url
    URL_FORMATS = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+(:[0-9]+)?|(?:ww‌​w.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?‌​(?:[\w]*))?)/
    require : 'ngModel',
    link : (scope, element, attrs, ngModel) !->
        ngModel.$parsers.push (value)->
            # 对于不以"https://"或"http://"开头的，加上"http://"
            unless /http/.test value
                unless /https/.test value
                    value = 'http://' + value 
            status = URL_FORMATS.test value
            ngModel.$setValidity 'url-characters', status
            value
