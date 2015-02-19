Node = React.createClass
	getDefaultProps: ->
		body: ''
		current: false
		collapsed: false
		children: []

	render: ->
		className = 'gtree-node'
		className += ' gtree-current' if @props.current
		className += ' gtree-collapsed' if @props.collapsed
		className += ' gtree-path' if @props.path
		React.createElement('li', { className }, @_renderBody(), @_renderChildren())

	_renderBody: ->
		React.createElement('div', { className:'gtree-body' }, @props.body)

	_renderChildren: ->
		React.createElement('ul', { className:'gtree-children' }, @_createChildElements(@props.children))

	_createChildElements: (children)->
		children.map (node, index)->
			node.index = index
			React.createElement(gtree.Node, node)

window.gtree = {} unless window.gtree
window.gtree.Node = Node
