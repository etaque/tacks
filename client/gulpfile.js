
'use strict';

var gulp        = require('gulp');
var $           = require('gulp-load-plugins')();
var browserify  = require('browserify');
var watchify    = require('watchify');
var reactify    = require('reactify');
var source      = require('vinyl-source-stream');
var shim        = require('browserify-shim');
var es6arrow    = require('es6-arrow-function');
var runSequence = require('run-sequence');

var buildDir   = '../public/';

function handleError(task) {
  return function(err) {
    $.util.log($.util.colors.red(err));
    $.notify.onError(task + " failed")(err);
  }
}

// see https://gist.github.com/mitchelkuijpers/11281981
function jsx(watch) {
  var doify = watch ? watchify : browserify;
  var bundler = doify('./scripts/main.js', { extensions: ['.jsx'] });

  bundler.transform(reactify);
  bundler.transform(shim);
  bundler.transform(es6arrow);

  var rebundle = function() {
    var stream = bundler.bundle({debug: true});

    stream.on('error', handleError('browserify'));

    return stream
      .pipe(source('main.js'))
      .pipe(gulp.dest(buildDir + 'javascripts'));
  };

  bundler.on('update', rebundle);
  return rebundle();
}

gulp.task('jsx', function() { return jsx(false) });
gulp.task('jsx:watch', function() { return jsx(true) });


gulp.task('compress', function() {
  gulp.src(buildDir + 'javascripts/main.js')
    .pipe($.uglify())
    .pipe(gulp.dest(buildDir + 'javascripts/dist'))
});

// Compile Any Other Sass Files You Added (app/styles)
gulp.task('scss', function () {
  return gulp.src('styles/**/*.scss')
    .pipe($.sass({
      style: 'expanded',
      precision: 10,
      loadPath: ['styles']
    }))
    .on('error', console.error.bind(console))
    .pipe(gulp.dest(buildDir + 'stylesheets'))
    .pipe($.size({title: 'scss'}));
});

// Watch Files For Changes & Reload
gulp.task('default', ['jsx:watch', 'scss'], function () {
  gulp.watch(['styles/**/*.scss'], ['scss']);
});

// Build Production Files, the Default Task
gulp.task('dist', function (cb) {
  runSequence('scss', ['jsx', 'compress'], cb);
});

