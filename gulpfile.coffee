coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
del = require 'del'
g = require 'gulp'
livereload = require 'gulp-livereload'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'
watch = require 'gulp-watch'
webserver = require 'gulp-webserver'

path =
	src:
		css: 'src/scss/**/*.scss'
		html: 'src/html/**/*.html'
		jsexample: 'src/coffee/*.coffee'
		js: [
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
		vender:
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

g.task 'js', ->
	g.src path.src.jsexample
		.pipe sourcemaps.init()
		.pipe coffee
			sourceMap: true
		.pipe sourcemaps.write()
		.pipe g.dest(path.dest.js)
		.pipe livereload()

	g.src path.src.js
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
		.pipe g.dest(path.dest.vender.js)

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
	'vender'
]

g.task 'default', [
	'build'
	'webserver'
	'watch'
]
