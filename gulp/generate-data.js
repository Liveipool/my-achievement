'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var jsf = require('json-schema-faker');
var fs = require('fs-extra');
var _ = require('lodash');


gulp.task('prepare-data', function ()
{
	var schemas = {}
	schemas.student = fs.readJSONSync(conf.paths.src + '/app/data/schema/student.json');
	jsf.extend('faker', function() {
		var faker = require('faker/locale/zh_CN');
		faker.custom = {
			name: function() {
				return faker.name.firstName() + faker.name.lastName();
			}
		}
		return faker;
	});
	console.log(schemas.student);
	var i, j, aclass, classes = [], classNum, studentNum, student;
	classNum = 2;
	studentNum = 50;
	for (i = 1; i <= classNum; ++i) {
		aclass = [];
		for (j = 0; j < studentNum; ++j) {
			student = jsf(schemas.student);
			if (_.random(1))
				delete student.TAscore;
			console.log(student);
			aclass.push(student);
		}
		classes.push(aclass);
	}
	fs.outputFileSync(conf.paths.src + '/app/data/faker/classes.json', JSON.stringify({data: classes}));
});
