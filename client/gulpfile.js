
'use strict';

var gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var browserify = require('browserify');
var runSequence = require('run-sequence');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');


var buildDir = '../public/';

function handleError(task) {
  return function(err) {
    $.util.log($.util.colors.white(err));
    $.notify.onError(task + " failed")(err);
  };
}


gulp.task('js', function() {
  var b = browserify({
    entries: './scripts/setup.js',
    debug: true
  });

  return b.bundle()
    .pipe(source('setup.js'))
    .pipe(buffer())
    .on('error', handleError("js"))
    .pipe(gulp.dest(buildDir + 'javascripts'));
});

gulp.task('compress', function() {
  gulp.src(buildDir + 'javascripts/setup.js')
    .pipe($.uglify())
    .pipe(gulp.dest(buildDir + 'javascripts/dist'));
});


gulp.task('elm', function() {
  return gulp.src('src/Main.elm')
    .pipe($.elm())
    .on('error', handleError("elm"))
    .pipe(gulp.dest(buildDir + 'javascripts'))
    .pipe($.size({title: 'elm'}));
});


gulp.task('scss', function () {
  return gulp.src('styles/**/*.scss')
    .pipe($.sass({
      style: 'expanded',
      precision: 10,
      loadPath: ['styles']
    }))
    .on('error', handleError("scss"))
    .pipe(gulp.dest(buildDir + 'stylesheets'))
    .pipe($.size({title: 'scss'}));
});


gulp.task('default', ['js', 'scss', 'elm'], function () {
  gulp.watch(['scripts/**/*.js'], ['js']);
  gulp.watch(['styles/**/*.scss'], ['scss']);
  gulp.watch(['src/**/*.elm'], ['elm']);
});

gulp.task('dist', function (cb) {
  runSequence('scss', ['js', 'compress'], cb);
});

