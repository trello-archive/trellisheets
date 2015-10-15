gulp = require 'gulp'
path = require 'path'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
less = require 'gulp-less'
minifyCSS = require 'gulp-minify-css'
rename = require 'gulp-rename'
LessPluginAutoPrefix = require 'less-plugin-autoprefix'

stylesSrc = './src/entries/*'

autoprefix = new LessPluginAutoPrefix
  browsers: [
    'chrome >= 35'
    'ie >= 10'
    'iOS >= 6'
    'ff >= 24'
    'safari >= 5.1'
  ]

gulp.task 'styles', ->

  gulp
    .src stylesSrc
    .pipe less
      paths: [path.join(__dirname, './src')]
      plugins: [autoprefix]
    .on 'error', (err) ->
      gutil.log(err)
      this.emit('end')
    .pipe gulp.dest('./public/styles')
    .pipe minifyCSS()
    .pipe rename
      suffix: ".min"
    .pipe gulp.dest('./public/styles')

gulp.task 'watch', ->
  gulp.watch './src/**/*', ['styles']

gulp.task 'default', ['styles', 'watch']
