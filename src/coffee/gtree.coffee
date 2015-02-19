TreeManager = (options)->
	if @ instanceof TreeManager
		return @constructor(options)
	else
		return new TreeManager(options)

TreeManager.prototype.VK =
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

TreeManager.prototype.constructor = (options)->
	$(document).on 'keypress', (event)=>
		VK = @VK
		switch event.keyCode
			when VK.a then @curTree and @curTree.append()
			when VK.d then @curTree and @curTree.delete()
			when VK.h then @curTree and @curTree.moveToParent()
			when VK.k then @curTree and @curTree.moveToPrev()
			when VK.j then @curTree and @curTree.moveToNext()
			when VK.l then @curTree and @curTree.moveToChild()
			when VK.o then @curTree and @curTree.insert()
			when VK.z then @curTree and @curTree.toggle()
			when VK.C then @curTree and @curTree.edit()
			when VK.O then @curTree and @curTree.insertBefore()
			when VK.S then @curTree and @curTree.edit()
			when VK.return then @curTree and @curTree.edit()
			when VK.space then @curTree and @curTree.toggle()

	return @

TreeManager.prototype.init = (options)->
	el = options.el
	if typeof el is 'string'
		el = document.querySelector(el)

	tree = React.render(React.createElement(Tree), el)
	tree.setData(options.data)

	@curTree = tree unless @curTree

	return tree

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

$ ->
	manager = TreeManager()
	manager.init
		el: '#gtree'
		data:
			body:'Root'
			current: true
			children: [
				{ body:'Child 1', children:[{ body:'1-1' }] }
				{ body:'Child 2' }
				{ body:'Child 3' }
			]
