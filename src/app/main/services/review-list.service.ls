'use strict'

angular.module 'fuse'

# TA/review-list
.service 'reviewListService' ($location, $anchor-scroll)!->
  @go-to-anchor = (class-id, group-id) ->
    new-hash = "class" + class-id + "-group" + group-id
    if $location.hash! !== new-hash
      $location.hash new-hash
    else
      $anchor-scroll!

  @get-student-users-by-class = (users) ->
    _.filter users, 'class'

  @get-classes = (student-users) ->
    _classes = _.groupBy student-users, 'class'
    # console.log _classes
    classes = []
    for id of _classes
      groups = []
      _groups = _.groupBy _classes[id], 'group'
      for _id of _groups
        groups.push {id: _id, members: _groups[_id]}
      classes.push {id: id, groups: groups, members: _classes[id]}
    return classes

  @add-ta-score-to-students = (ta-reviews, student-users)!->
    for i from 0 to ta-reviews.length - 1 by 1
      for j from 0 to student-users.length - 1 by 1
        if ta-reviews[i].reviewee.username ~= student-users[j].username
          student-users[j].ta-score = ta-reviews[i].score
          break

  @add-teacher-score-to-students = (teacher-reviews, student-users)!->
    for i from 0 to teacher-reviews.length - 1 by 1
      for j from 0 to student-users.length - 1 by 1
        if teacher-reviews[i].reviewee.username ~= student-users[j].username
          student-users[j].teacher-score = teacher-reviews[i].score
          break


