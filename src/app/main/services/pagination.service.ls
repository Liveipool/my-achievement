'use strict'

angular.module 'fuse'

# student/homework-detail
.factory 'paginationService' ->
    pagination = {}

    pagination.get-new = (perPage)->

        if perPage === undefined
            perPage = 10

        # console.log perPage

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
