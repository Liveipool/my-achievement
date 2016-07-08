'use strict'

angular.module 'app.TA'

.config ($state-provider) !->
  $state-provider.state 'app.TA.review.dashboard', {
    url: '/homework/TA-review-list'
    resolve:
      data: (api-resolver) -> api-resolver.resolve('classes@get')
    views:
      'content@app':
        template-url: 'app/main/TA/review/dashboard/review-dashboard.html'
        controller-as : 'vm'
        controller: ($scope, $filter, Authentication, data, DTOptionsBuilder)!->
          console.log "review-dashboard"
          #console.log(data.data);
          @user = Authentication.get-user!
          @classes = data.data
          @dtInstances = []
          @searchWords = []
          for x in @classes
            @dtInstances.push {}
            @searchWords.push ''
          @dtOptions = DTOptionsBuilder.newOptions! .withDisplayLength 10 .withPaginationType 'simple' .withDOM 'tip'
          @search = (index)!~>
            @dtInstances[index] .DataTable .columns 0 .search @searchWords[index] .draw!
  }

.filter 'searchName', ->
  (datas, name)->
    console.log datas
    console.log name
    console.log name.length

    newData = []
    for data in datas
      if (!name || name.length == 0 || data.name.includes name)
        newData.push data
    newData
