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

		$(document).on 'keypress', (event)=>
			switch event.keyCode
				when VK.a then tree.append()
				when VK.d then tree.delete()
				when VK.h then tree.moveToParent()
				when VK.k then tree.moveToPrev()
				when VK.j then tree.moveToNext()
				when VK.l then tree.moveToChild()
				when VK.o then tree.insert()
				when VK.z then tree.toggle()
				when VK.C then tree.edit()
				when VK.O then tree.insertBefore()
				when VK.S then tree.edit()
				when VK.return then tree.edit()
				when VK.space then tree.toggle()

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
		React.createElement('li', { className }, @_renderBody(), @_renderChildren())

	_renderBody: ->
		React.createElement('div', { className:'gtree-body' }, @props.body)

	_renderChildren: ->
		React.createElement('ul', { className:'gtree-children' }, @_createChildElements(@props.children))

	_createChildElements: (children)->
		children.map (node, index)->
			React.createElement(Node, $.extend({}, node, {key:index}))

Tree = React.createClass
	getInitialState:->
		data: null

	render: ->
		React.createElement('ul', @_getAttr(), @_renderChildren())

	_getAttr: ->
		className: 'gtree-children'

	_renderChildren: ->
		React.createElement(Node, @state.data) if @state.data

	setData: (data)->
		data = @curNode = @_initializeData(data)
		@setState({data})

	_initializeData: (node, parent, index)->
		node.index = index
		node.parent = parent
		node.children = [] unless node.children

		node.children.map (child, index)=>
			@_initializeData(child, node, index)

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

	append: ->
		body = @_promptNew()
		if body
			cur = @curNode
			next = @_initializeData({body}, cur, cur.children.length)
			cur.children.push(next)
			@_moveTo(next)

	insert: (before)->
		body = @_promptNew()
		if body
			cur = @curNode
			index = cur.index + (if before then 0 else 1)
			parent = cur.parent
			next = @_initializeData({body}, parent, index)

			bros = parent.children
			bros2 = bros.splice(index)
			bros.push(next)
			bros2.forEach (node, index)->
				node.index++
				bros.push(node)

			@_moveTo(next)

	insertBefore: ->
		@insert(true)

	_promptNew: ->
		window.prompt('Input the body for the new node')

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
