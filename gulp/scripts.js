'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');

var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'merge-stream']
});

gulp.task('scripts-reload', function ()
{
    return buildScripts()
        .pipe(browserSync.stream());
});

gulp.task('scripts', function ()
{
    return buildScripts();
});

function buildScripts()
{
    var _livescript = conf.livescript();
    var _javascript = gulp.src([
        path.join(conf.paths.src, '/app/**/*.js'),
        path.join(conf.paths.gfc, '/adapters/**/*.js')
    ]);
    return $.mergeStream(_javascript, _livescript)
        // Enable the following two lines if you want linter
        // to check your code every time the scripts reloaded
        //.pipe($.eslint())
        //.pipe($.eslint.format())
        
        // .pipe($.debug());
};

