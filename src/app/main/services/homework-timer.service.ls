'use strict'

angular.module 'fuse'
.factory 'timerService', ->
  calculate = (start, end, status) ->
    nowTime = new Date!
    startTime = new Date start
    endTime = new Date end

    if nowTime < startTime
      status = 'future'
      iRemain = (startTime.getTime! - nowTime.getTime!)/1000
    else if nowTime < endTime
      status = 'present'
      iRemain = (endTime.getTime! - nowTime.getTime!)/1000
    else
      status = 'finish'
      iRemain = 0

    remain = {}
    remain.days =  parseInt iRemain/86400
    iRemain %= 86400
    remain.hours = parseInt iRemain/3600
    iRemain %= 3600
    remain.mins = parseInt iRemain/60
    iRemain %= 60
    remain.secs = parseInt iRemain
    remain.status = status

    timeSum = 0
    for key, value of remain
      timeSum = timeSum + value
    if timeSum == 0 and status == 'future' then remain.status = 'present'
    if timeSum == 0 and status == 'present' then remain.status = 'finish'
      # body...
    remain

  calculateRemain: (start, end, status)->
    calculate start, end, status