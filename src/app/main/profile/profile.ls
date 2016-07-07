'use strict'

angular.module 'app.profile', []

.config ($state-provider) !->
  $state-provider.state 'app.profile', {
    # abstract: true
    url: '/profile'
    views:
      'content@app':
        template-url: 'app/main/profile/profile.html'
        controller-as: 'vm'
        controller: (Authentication) !->
          # console.log Authentication.get-user!
          @raw-user-data = Authentication.get-user!
          @user = _.update @raw-user-data, 'gender', (gender)-> if gender is 'male' then '男' else '女'
          # console.log @user
          @bg = "bg" + Math.ceil(12 * (Math.random!))
          # console.log("bg: ", @bg)
          @change-password-count = 0
          @change-password-hint = "下一步"
          that = @
          @change-password = ->
            that.change-password-count++
            # console.log("change-password-count: ", that.change-password-count)
            that.change-password-hint = if that.change-password-count is 2 then '确认更改' else '下一步'
          # console.log(@change-password-count)
          @clear = ->
            that.change-password-count = 0
    }

