Path = React.createClass
	render: ->
		delimiterString = @props.delimiter
		path = []
		@props.dirs.forEach (dir, index)->
			path.push React.createElement('span', { className:'gtree-path-dir' }, dir)
			path.push React.createElement('span', { className:'gtree-path-delimiter' }, delimiterString)
		path.pop()

		React.createElement('div', { className:'gtree-path' }, path)

window.gtree = {} unless window.gtree
window.gtree.Path = Path
