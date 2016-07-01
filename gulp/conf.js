/**
 *  This file contains the variables used in other gulp files
 *  which defines tasks
 *  By design, we only put there very generic config values
 *  which are used in several places to keep good readability
 *  of the tasks
 */

var gutil = require('gulp-util');
var gulp = require('gulp');
var path = require('path');
var $ = require('gulp-load-plugins')();

/**
 *  The main paths of your project handle these with care
 */

exports.paths = {
    src : 'src',
    dist: 'dist',
    tmp : '.tmp',
    e2e : 'e2e',
    gfc : '.tmp/gfc'
};

/**
 *  Wiredep is the lib which inject bower dependencies in your project
 *  Mainly used to inject script tags in the index.html but also used
 *  to inject css preprocessor deps and js files in karma
 */
exports.wiredep = {
    directory: 'bower_components'
};

/**
 *  Common implementation for an error handler of a Gulp plugin
 */
exports.errorHandler = function (title)
{
    'use strict';

    return function (err)
    {
        gutil.log(gutil.colors.red('[' + title + ']'), err.toString());
        this.emit('end');
    };
};

/**
 *  Common compile jade
 */
exports.jade = function()
{
    return gulp.src([
            path.join(exports.paths.src, '/app/**/*.jade'),
            path.join(exports.paths.gfc, '/widgets/**/*.jade'),
            '!' + path.join(exports.paths.src, 'app/**/*.partial.jade')
        ])
        .pipe($.jade({pretty: true, basedir: '.'}))
            .pipe($.size())
        .on('error', exports.errorHandler('jade'))
}

/**
 *  Common compile livescript
 */

exports.livescript = function()
{
    return gulp.src([
            path.join(exports.paths.src, '/app/**/*.ls'),
            path.join('!' + exports.paths.src, '/app/**/*.ui.ls'),
        ])
        .pipe($.livescript({bare: false}))
        .on('error', exports.errorHandler('livescript'))
        .pipe(gulp.dest(path.join(exports.paths.tmp, '/serve/app')));
}

