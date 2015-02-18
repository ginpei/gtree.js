coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
del = require 'del'
g = require 'gulp'
livereload = require 'gulp-livereload'
# rename = require 'gulp-rename'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'
watch = require 'gulp-watch'
webserver = require 'gulp-webserver'

path =
	src:
		css: 'src/scss/**/*.scss'
		html: 'src/html/**/*.html'
		js: 'src/coffee/**/*.coffee'
		jslib: [
			'bower_components/jquery/dist/jquery.min.js'
			'bower_components/react/react.js'
		]
	dest:
		css: 'public/css'
		html: 'public'
		js: 'public/js'
		jslib: 'public/js'

g.task 'clean', ->
	del 'public'

g.task 'css', ->
	g.src path.src.css
		.pipe sass( style:'minify' )
		.pipe g.dest(path.dest.css)
		.pipe livereload()

g.task 'html', ->
	g.src path.src.html
		.pipe g.dest(path.dest.html)
		.pipe livereload()

g.task 'js', ->
	g.src path.src.js
		.pipe sourcemaps.init()
		.pipe coffee
			sourceMap: true
		.pipe sourcemaps.write()
		.pipe g.dest(path.dest.js)
		.pipe livereload()

g.task 'lib', ->
	g.src path.src.jslib
		.pipe concat('libs.js')
		.pipe g.dest(path.dest.jslib)

g.task 'watch', ->
	livereload.listen()
	watch path.src.css, -> g.start 'css'
	watch path.src.html, -> g.start 'html'
	watch path.src.js, -> g.start 'js'
	watch 'gulpfile.coffee', -> g.start 'build'

g.task 'webserver', ->
	g.src 'public'
		.pipe webserver
			host: '0.0.0.0'
			port: 3000

g.task 'build', [
	'css'
	'html'
	'js'
	'lib'
]

g.task 'default', [
	'build'
	'webserver'
	'watch'
]
