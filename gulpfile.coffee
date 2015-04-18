coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
del = require 'del'
g = require 'gulp'
livereload = require 'gulp-livereload'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'
webserver = require 'gulp-webserver'

path =
	src:
		css: 'src/scss/**/*.scss'
		html: 'src/html/**/*.html'
		jsExample: 'src/coffee/*.coffee'
		jsMain: [
			'src/coffee/gtree/Manager.coffee'
			'src/coffee/gtree/Tree.coffee'
			'src/coffee/gtree/Path.coffee'
			'src/coffee/gtree/Node.coffee'
		]
		vender:
			js: [
				'bower_components/react/react.js'
				'libs/keymapstring.js/keymapstring.js'
			]
	dest:
		css: 'public/css'
		html: 'public'
		js: 'public/js'

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

g.task 'jsExample', ->
	g.src path.src.jsExample
		.pipe sourcemaps.init()
		.pipe coffee
			sourceMap: true
		.pipe sourcemaps.write()
		.pipe g.dest(path.dest.js)
		.pipe livereload()

g.task 'jsMain', ->
	g.src path.src.jsMain
		.pipe sourcemaps.init()
		.pipe coffee
			sourceMap: true
		.pipe concat('gtree.js')
		.pipe sourcemaps.write()
		.pipe g.dest(path.dest.js)
		.pipe livereload()

g.task 'vender', ->
	g.src path.src.vender.js
		.pipe concat('libs.js')
		.pipe g.dest(path.dest.js)

g.task 'watch', ['webserver'], ->
	livereload.listen()
	g.watch path.src.css, ['css']
	g.watch path.src.html, ['html']
	g.watch path.src.jsExample, ['jsExample']
	g.watch path.src.jsMain, ['jsMain']

g.task 'webserver', ['build'], ->
	g.src 'public'
		.pipe webserver
			host: '0.0.0.0'
			port: 3000

g.task 'build', [
	'css'
	'html'
	'jsExample'
	'jsMain'
	'vender'
]

g.task 'default', [ 'watch' ]
