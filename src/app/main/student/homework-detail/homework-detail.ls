'use strict'

angular.module 'app.student'

.config ($state-provider) !->
    $state-provider.state 'app.student.homework-detail', {
        url: '/homework-detail'
        resolve:
            result: (api-resolver) -> api-resolver.resolve 'reviews@get'
            user: (Authentication)-> Authentication.getUser!
        views:
            'content@app':
                template-url: 'app/main/student/homework-detail/homework-detail.html'
                controller-as: 'vm'
                controller: (result, user, Interaction)!->
                    vm = @
                    vm.reviews = result.data
                    vm.user = user
                    vm.greeting = vm.user.fullname
                    vm.location = '作业详情'
                    vm.theme = Interaction.get-bg-by-month 2
                    username = vm.user.username
                    # console.log vm.reviews
                    console.log user

                    homeworks = _.filter vm.reviews, (review)->
                        review.reviewee.username == username

                    vm.num-of-sixty-to-seventy = 0
                    vm.num-of-seventy-to-eighty = 0
                    vm.num-of-eighty-to-ninety = 0
                    vm.num-of-failed = 0
                    vm.num-of-ninety-to-full = 0

                    console.log homeworks
                    homeworks.forEach (homework)!->
                        console.log homework.reviewer
                        if (homework.reviewer.role != 'teacher')
                            return

                        score = homework.finalScore

                        if (score < 60)
                            vm.num-of-failed++
                        else if (score >= 60 and score < 70)
                            vm.num-of-sixty-to-seventy++
                        else if (score >= 70 and score < 80)
                            vm.num-of-seventy-to-eighty++
                        else if (score >= 80 and score < 90)
                            vm.num-of-eighty-to-ninety++
                        else if (score >= 90 and score <= 100)
                            vm.num-of-ninety-to-full++

                    # console.log vm.num-of-eighty-to-ninety
                    vm.widget6 = {
                        title       : '作业成绩分布'
                        mainChart   :
                            config :
                                refreshDataOnly: true
                                deepWatchData  : true

                            options:
                                chart:
                                    type        : 'pieChart',
                                    color       : ['#f44336', '#9c27b0', '#03a9f4', '#e91e63']
                                    height      : 400
                                    margin      :
                                        top   : 0
                                        right : 0
                                        bottom: 0
                                        left  : 0

                                    donut       : true
                                    clipEdge    : true
                                    cornerRadius: 0
                                    labelType   : 'percent'
                                    padAngle    : 0.02
                                    x           :  (d)->
                                                    d.label
                                    y           : (d)->
                                        return d.value
                                    tooltip     :
                                        gravity: 's'
                                        classes: 'gravity-s'
                            data   : [
                                {
                                    label: '<60'
                                    value: vm.num-of-failed
                                },
                                {
                                    label: '60~70'
                                    value: vm.num-of-sixty-to-seventy
                                },
                                {
                                    label: '70~80'
                                    value: vm.num-of-seventy-to-eighty
                                },
                                {
                                    label: '80~90'
                                    value: vm.num-of-eighty-to-ninety
                                },
                                {
                                    label: '90~100'
                                    value: vm.num-of-ninety-to-full
                                }
                            ]

                    }



                    vm.widget7 = {
                        title       : '作业排名',
                        ranges      : {
                            '作业1': '作业 1'
                            '作业2': '作业 2'
                            '作业3': '作业 3'
                            '作业4': '作业 4'
                            '作业5': '作业 5'
                            '作业6': '作业 6'
                            '作业7': '作业 7'
                            '作业8': '作业 8'
                            '作业9': '作业 9'
                            '作业10': '作业 10'
                            '作业11': '作业 11'
                        }
                        ranklists    : {}
                        currentRange: '作业1'
                    }

                    final-reviews = _.filter vm.reviews, (review)->
                        review.reviewer.role == 'teacher'

                    for i in [1 to 20]
                        hw_ranklist = _.filter final-reviews, (review)->
                                    review.homework_id == i and review.class == user.class
                        vm.widget7.ranklists['作业'+i] = _.order-by hw_ranklist, 'score', 'desc'

                    # console.log vm.widget7.ranklists['HW1']

                    # console.log vm.widget7.ranklists
    }