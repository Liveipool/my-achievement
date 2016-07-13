'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var jsf = require('json-schema-faker');
var fs = require('fs-extra');
var _ = require('lodash');
var faker = require('faker');
var moment = require('moment');


gulp.task('prepare-data', function ()
{
	var schemas = {};
	var reviewArr = [];
	var users = fs.readJSONSync(conf.paths.src + '/app/data/auth/users.json').user;

	var taAndTeacher = _.filter(users, function(user) {
	  		return user.role == 'ta' || user.role == 'teacher';
	  	})
	users.forEach(function(user) {
	if (user.role == 'student')

	  for(var i = 1; i <= 20; i++) {

	  	var reviewerGroup = (user.group+i)%5+1
	  	var reviewerClass = user.class

	  	var reviewers = _.filter(users, function(user) {
	  		return user.group == reviewerGroup && user.class == reviewerClass;
	  	})

	  	reviewers = reviewers.concat(taAndTeacher)



	  	reviewers.forEach(function(reviewer) {

		var review = {};
		review.reviewee = {};
		review.reviewee.username = user.username;
		review.reviewee.fullname = user.fullname;

		review.reviewer = {};
		review.reviewer.username = reviewer.username;
		review.reviewer.fullname = reviewer.fullname;
		review.reviewer.role = reviewer.role;


	  	
		review.homework_id = i;
		review.score = _.random(60, 100);
		if (reviewer.role == 'teacher')
			review.finalScore = review.score
		review.comment = 'blablabra';
		review.class = user.class;
		review.group = user.group;
		reviewArr.push(review)

	  	})



	  }
	})
	// console.log(reviewArr)
	fs.outputFileSync(conf.paths.src + '/app/data/faker/reviews.json', JSON.stringify({data: reviewArr}));


	// var schemas = {}
	// schemas.student = fs.readJSONSync(conf.paths.src + '/app/data/schema/student.json');
 // 	jsf.extend('faker', function() {
	// 	var faker = require('faker/locale/zh_CN');
	// 	faker.custom = {
	// 		name: function() {
	// 			return faker.name.firstName() + faker.name.lastName();
	// 		}
	// 	}
	// 	return faker;
	// });
	// // console.log(schemas.student);
	// var i, j, aClass, classes = [], classNum, studentNum, student;
	// classNum = 2;
	// studentNum = 50;
	// for (i = 1; i <= classNum; ++i) {
	// 	aClass = [];
	// 	for (j = 0; j < studentNum; ++j) {
	// 		student = jsf(schemas.student);
	// 		if (_.random(1))
	// 			delete student.TAscore;
	// 		console.log(student);
	// 		aClass.push(student);
	// 	}
	// 	classes.push(aClass);
	// }
	// fs.outputFileSync(conf.paths.src + '/app/data/faker/classes.json', JSON.stringify({data: classes}));
	// var homeworks = [], homework, homeworkNum;
	// homeworkNum = 20;
	// for (i = 1; i <= homeworkNum; ++i) {
	// 	homework = {};
	// 	homework.id = i;
	// 	homework.title = "第" + i + "次作业"
	// 	homework.classes = [];
	// 	for (j = 1; j <= classNum; ++j) {
	// 		aClass = {};
	// 		aClass.class_id = j;
	// 		aClass.description = "www.baidu.com"
	// 		aClass.startTime = faker.date.between(moment().subtract(18, 'days').toDate(), moment().add(2, 'days').toDate());
	// 		console.log(aClass.startTime);
	// 		aClass.endTime = moment(aClass.startTime).add(_.random(4, 12), 'days').toDate();
	// 		console.log(aClass.endTime);
	// 		if (moment().isBefore(aClass.startTime)) {
	// 			aClass.status = "future";
	// 		} else if (moment().isBefore(aClass.endTime)) {
	// 			aClass.status = "current";
	// 		} else {
	// 			aClass.status = "finish";
	// 		}
	// 		homework.classes.push(aClass);
	// 	}
	// 	homeworks.push(homework);
	// }
	// fs.outputFileSync(conf.paths.src + '/app/data/faker/homeworks.json', JSON.stringify({data: homeworks}));
});
