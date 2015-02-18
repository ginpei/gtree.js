VK =
	return: 13
	space: 32
	C: 67
	O: 79
	S: 83
	a: 97
	d: 100
	h: 104
	j: 106
	k: 107
	l: 108
	o: 111
	z: 122

CLS =
	collapsed: 'gtree-collapsed'
	current: 'gtree-current'

gtree =
	start: ->
		tree = React.render(React.createElement(Tree), document.getElementById('gtree'))
		tree.setData
			body:'Root'
			current: true
			children: [
				{ body:'Child 1', children:[{ body:'1-1' }] }
				{ body:'Child 2' }
				{ body:'Child 3' }
			]

		@$curNode = $('#gtree .gtree-node:first')

		$(document).on 'keypress', (event)=>
			switch event.keyCode
				when VK.a then @append()
				when VK.d then tree.delete()
				when VK.h then tree.moveToParent()
				when VK.k then tree.moveToPrev()
				when VK.j then tree.moveToNext()
				when VK.l then tree.moveToChild()
				when VK.o then @insert()
				when VK.z then tree.toggle()
				when VK.C then tree.edit()
				when VK.O then @insertBefore()
				when VK.S then tree.edit()
				when VK.return then tree.edit()
				when VK.space then tree.toggle()

	append: ->
		node = @createNew()
		if node
			@$curNode.children('.gtree-children').append(node.$el)
			@moveTo(node.$el)

	delete: ->
		return if @isRoot()

		$node = @$curNode
		@moveToNext()
		if @$curNode is $node
			@moveToPrev()
			if @$curNode is $node
				@moveToParent()
		$node.remove()

	moveToParent: ->
		@moveTo(@$curNode.parents('.gtree-node:first'))
	moveToPrev: ->
		@moveTo(@$curNode.prev())
	moveToNext: ->
		@moveTo(@$curNode.next())
	moveToChild: ->
		@moveTo(@$curNode.find('.gtree-node:first'))

	moveTo: ($node)->
		if $node.length > 0
			@$curNode.removeClass(CLS.current)
			$node.addClass(CLS.current)
			@$curNode = $node

	insert: ->
		return if @isRoot()

		node = @createNew()
		if node
			@$curNode.after(node.$el)
			@moveTo(node.$el)

	insertBefore: ->
		return if @isRoot()

		node = @createNew()
		if node
			@$curNode.before(node.$el)
			@moveTo(node.$el)

	edit: ->
		$body = @$curNode.find('>.gtree-body')
		body = $body.text()
		body = window.prompt 'Input the body', body
		if body
			$body.text(body)

	toggle: ->
		@$curNode.toggleClass(CLS.collapsed) if @$curNode.find('.gtree-node').length > 0

	createNew: ->
		body = window.prompt('Input the body for the new node')
		if body
			node = new gtree.Node
				data:
					body: body
			node.render()
			return node
		else
			return null

	isRoot: ($node = @$curNode)->
		return $node.parent().hasClass('gtree')

Node = gtree.Node = (options)->
	if @ instanceof Node
		@.initialize(options)
	else
		new Node(options)

$.extend gtree.Node.prototype,
	initialize: (options = {})->
		@parent = options.parent
		@index = options.index
		@data = options.data
		@children = []
		return @

	render: ->
		@$el = $(window.template(@data))
		@$childrenContainer = @$el.children( '.gtree-children')
		return @

	append: (node)->
		@children.push(node)
		node.setParent(@)
		@$childrenContainer.append(node.$el)
		return @

	setParent: (node)->
		@parent = node
		return @

Node2 = React.createClass
	getDefaultProps: ->
		body: ''
		current: false
		collapsed: false
		children: []

	render: ->
		className = 'gtree-node'
		className += ' gtree-current' if @props.current
		className += ' gtree-collapsed' if @props.collapsed
		React.createElement('li', { className }, @_renderBody(), @_renderChildren())

	_renderBody: ->
		React.createElement('div', { className:'gtree-body' }, @props.body)

	_renderChildren: ->
		React.createElement('ul', { className:'gtree-children' }, @_createChildElements(@props.children))

	_createChildElements: (children)->
		children.map (node, index)->
			React.createElement(Node2, $.extend({}, node, {key:index}))

Tree = React.createClass
	getInitialState:->
		data: null

	render: ->
		React.createElement('ul', @_getAttr(), @_renderChildren())

	_getAttr: ->
		className: 'gtree-children'

	_renderChildren: ->
		React.createElement(Node2, @state.data) if @state.data

	setData: (data)->
		data = @curNode = @_initializeData(data)
		@setState({data})

	_initializeData: (node, index, parent)->
		node.index = index
		node.parent = parent
		node.children?.map (child, index)=>
			@_initializeData(child, index, node)

		return node

	moveToParent: ->
		@_moveTo(@curNode.parent)

	moveToChild: ->
		@_moveTo(@curNode.children?[0])

	moveToPrev: ->
		@_moveTo(@curNode.parent?.children?[@curNode.index-1])

	moveToNext: ->
		@_moveTo(@curNode.parent?.children?[@curNode.index+1])

	_moveTo: (next)->
		if next
			@curNode.current = false
			next.current = true
			@curNode = next
			@setState(data:@state.data)

	edit: ->
		body = window.prompt 'Input the body', @curNode.body
		if body
			@curNode.body = body
			@setState(data:@state.data)

	toggle: ->
		@curNode.collapsed = !@curNode.collapsed
		@setState(data:@state.data)

	delete: ->
		old = @curNode
		@moveToNext()
		if @curNode is old
			@moveToPrev()
			if @curNode is old
				@moveToParent()

		if @curNode isnt old
			children = old.parent.children
			children.splice(old.index, 1)
			children.map (node, index) -> node.index = index
			@setState(data:@state.data)

window.gtree = gtree

$ -> gtree.start()
