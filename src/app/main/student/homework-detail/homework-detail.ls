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
                controller: (result, user, Pagination, Interaction)!->
                    vm = @
                    vm.reviews = result.data
                    vm.user = user
                    vm.greeting = vm.user.fullname
                    vm.location = '作业详情'
                    vm.theme = Interaction.get-bg-by-month 2
                    vm.pagination = Pagination.get-new!
                    vm.reset-current-page = (currentRange)!->
                        vm.get-class-scores-distribution(currentRange)
                        vm.pagination.currentPage = 0
                    username = vm.user.username



                    vm.person-num-of-sixty-to-seventy = 0
                    vm.person-num-of-seventy-to-eighty = 0
                    vm.person-num-of-eighty-to-ninety = 0
                    vm.person-num-of-failed = 0
                    vm.person-num-of-ninety-to-full = 0

                    vm.class-num-of-sixty-to-seventy = 0
                    vm.class-num-of-seventy-to-eighty = 0
                    vm.class-num-of-eighty-to-ninety = 0
                    vm.class-num-of-failed = 0
                    vm.class-num-of-ninety-to-full = 0

                    person-homeworks = _.filter vm.reviews, (review)->
                        review.reviewee.username == username

                    # console.log homeworks
                    person-homeworks.forEach (homework)!->
                        # console.log homework.reviewer
                        if (homework.reviewer.role != 'teacher') 
                            return 

                        score = homework.finalScore

                        if (score < 60)
                            vm.person-num-of-failed++
                        else if (score >= 60 and score < 70)
                            vm.person-num-of-sixty-to-seventy++
                        else if (score >= 70 and score < 80)
                            vm.person-num-of-seventy-to-eighty++
                        else if (score >= 80 and score < 90)
                            vm.person-num-of-eighty-to-ninety++
                        else if (score >= 90 and score <= 100)
                            vm.person-num-of-ninety-to-full++



                    # console.log vm.person-num-of-eighty-to-ninety
                    vm.person-score = {
                        title       : '个人作业成绩分布'
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
                                    value: vm.person-num-of-failed
                                },
                                {
                                    label: '60~70'
                                    value: vm.person-num-of-sixty-to-seventy
                                },
                                {
                                    label: '70~80'
                                    value: vm.person-num-of-seventy-to-eighty
                                },
                                {
                                    label: '80~90'
                                    value: vm.person-num-of-eighty-to-ninety
                                },
                                {
                                    label: '90~100'
                                    value: vm.person-num-of-ninety-to-full
                                }
                            ]

                    }


                    vm.class-score = {
                        title       : '全班作业成绩分布'
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
                                    value: vm.class-num-of-failed
                                },
                                {
                                    label: '60~70'
                                    value: vm.class-num-of-sixty-to-seventy
                                },
                                {
                                    label: '70~80'
                                    value: vm.class-num-of-seventy-to-eighty
                                },
                                {
                                    label: '80~90'
                                    value: vm.class-num-of-eighty-to-ninety
                                },
                                {
                                    label: '90~100'
                                    value: vm.class-num-of-ninety-to-full
                                }
                            ]

                    }


                    vm.class-homeworks = {
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

                    for i in [1 to final-reviews.length]
                        hw_ranklist = _.filter final-reviews, (review)->
                                    review.homework_id == i and review.class == user.class
                        vm.class-homeworks.ranklists['作业'+i] = _.order-by hw_ranklist, 'score', 'desc'

                    # console.log vm.class-homeworks.ranklists['HW1']

                    # console.log vm.class-homeworks.ranklists

                    vm.pagination.numOfPages = Math.ceil(vm.class-homeworks.ranklists[vm.class-homeworks.currentRange].length/vm.pagination.pageSize)

                    vm.class-scores-distribution = {}

                    vm.get-class-scores-distribution = (currentRange)!->
                        distribution = vm.class-scores-distribution[currentRange]
                        if distribution
                            vm.class-num-of-failed = distribution.class-num-of-failed
                            vm.class-num-of-sixty-to-seventy = distribution.class-num-of-sixty-to-seventy
                            vm.class-num-of-seventy-to-eighty = distribution.class-num-of-seventy-to-eighty
                            vm.class-num-of-eighty-to-ninety = distribution.class-num-of-eighty-to-ninety
                            vm.class-num-of-ninety-to-full = distribution.class-num-of-ninety-to-full
                        else
                            vm.class-num-of-failed = 0 
                            vm.class-num-of-sixty-to-seventy = 0
                            vm.class-num-of-seventy-to-eighty = 0 
                            vm.class-num-of-eighty-to-ninety = 0
                            vm.class-num-of-ninety-to-full = 0

                            console.log currentRange

                            vm.class-homeworks.ranklists[currentRange].for-each (homework)!->

                                score = homework.finalScore

                                if (score < 60)
                                    vm.class-num-of-failed++
                                else if (score >= 60 and score < 70)
                                    vm.class-num-of-sixty-to-seventy++
                                else if (score >= 70 and score < 80)
                                    vm.class-num-of-seventy-to-eighty++
                                else if (score >= 80 and score < 90)
                                    vm.class-num-of-eighty-to-ninety++
                                else if (score >= 90 and score <= 100)
                                    vm.class-num-of-ninety-to-full++

                        console.log vm.class-num-of-eighty-to-ninety

                        vm.class-scores-distribution[vm.class-homeworks.currentRange] =
                            class-num-of-failed : vm.class-num-of-failed
                            class-num-of-sixty-to-seventy : vm.class-num-of-sixty-to-seventy
                            class-num-of-seventy-to-eighty : vm.class-num-of-seventy-to-eighty
                            class-num-of-eighty-to-ninety : vm.class-num-of-eighty-to-ninety
                            class-num-of-ninety-to-full : vm.class-num-of-ninety-to-full  

                        vm.class-score.mainChart.data  = [
                            {
                                label: '<60'
                                value: vm.class-num-of-failed
                            },
                            {
                                label: '60~70'
                                value: vm.class-num-of-sixty-to-seventy
                            },
                            {
                                label: '70~80'
                                value: vm.class-num-of-seventy-to-eighty
                            },
                            {
                                label: '80~90'
                                value: vm.class-num-of-eighty-to-ninety
                            },
                            {
                                label: '90~100'
                                value: vm.class-num-of-ninety-to-full
                            }
                        ]

                    vm.scores-init = !->
                        vm.get-class-scores-distribution('作业1')

                    vm.scores-init!



    }

.filter 'startFrom', ->
    (input, start)->
        if (input === undefined)
            return input
        else
            return input.slice +start

.factory 'Pagination', ->
    pagination = {}

    pagination.get-new = (perPage)->

        if perPage === undefined
            perPage = 10

        console.log perPage

        paginator = 
            numOfPages: 1
            pageSize: perPage
            currentPage: 0

        paginator.prev-page = !->
            if not paginator.is-first-page!
                paginator.currentPage -= 1

        paginator.next-page = !->
            if not paginator.is-last-page!
                paginator.currentPage += 1

        paginator.is-last-page = ->
            paginator.currentPage >= paginator.numOfPages - 1

        paginator.is-first-page = ->
            paginator.currentPage == 0

        paginator
    pagination

