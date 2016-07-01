'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');

var browserSync = require('browser-sync');

function isOnlyChange(event)
{
    return event.type === 'changed';
}

gulp.task('jade-dev', function(){
    return conf.jade()
      .pipe(gulp.dest(conf.paths.tmp + '/serve/app/'));

});

gulp.task('watch', ['inject', 'jade-dev'], function ()
{
    gulp.watch([path.join(conf.paths.src, '/*.html'), 'bower.json'], ['inject-reload']);

    gulp.watch([
        path.join(conf.paths.src, '/app/**/*.css'),
        path.join(conf.paths.src, '/app/**/*.{scss,sass}'),
        path.join(conf.paths.gfc, '/adapters/**/*.{scss,sass}')
    ], function (event)
    {
        if ( isOnlyChange(event) )
        {
            gulp.start('styles-reload');
        }
        else
        {
            gulp.start('inject-reload');
        }
    });

    gulp.watch([
        path.join(conf.paths.src, '/app/**/*.{js,ls,json.ls}'),
        path.join(conf.paths.gfc, '/adapters/**/*.js'),
        path.join('!' + conf.paths.src, '/app/**/*.ui.ls')
    ], function (event)
    {
        if ( isOnlyChange(event) )
        {
            gulp.start('scripts-reload');
        }
        else
        {
            gulp.start('inject-reload');
        }
    });

    gulp.watch([
        path.join(conf.paths.src, '/app/**/*.json'),
        path.join(conf.paths.src, '/app/**/*.html'),
        path.join(conf.paths.tmp, '/app/**/*.html')
    ], function (event)
    {   
        console.log("********** html reload at: ", event.path);
        browserSync.reload(event.path);
    });

    gulp.watch([
        path.join(conf.paths.src, '/app/**/*.jade'),
        path.join(conf.paths.gfc, '/widgets/**/*.jade')
    ], function (event)
    {   
        gulp.start('jade-dev');
        browserSync.reload(event.path);
    });

    gulp.watch([
        path.join(conf.paths.src, '/app/**/*.ui.ls')
    ], function (event)
    {   
        gulp.start('gfc');
    });
});