Node = React.createClass
	getDefaultProps: ->
		body: ''
		current: false
		collapsed: false
		children: []
		renderBody: (props)-> props.body

	render: ->
		className = 'gtree-node'
		className += ' gtree-current' if @props.current
		className += ' gtree-collapsed' if @props.collapsed
		className += ' gtree-on-path' if @props.path
		React.createElement('li', { className }, @_renderBody(), @_renderChildren())

	_renderBody: ->
		@props.renderBody(@props)

	_renderChildren: ->
		React.createElement('ul', { className:'gtree-children' }, @_createChildElements(@props.children))

	_createChildElements: (children)->
		renderBody = @props.renderBody
		children.map (node, index)->
			node.index = index
			node.renderBody = renderBody
			React.createElement(gtree.Node, node)

window.gtree.Node = Node
