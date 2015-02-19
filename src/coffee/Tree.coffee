Tree = React.createClass
	getInitialState:->
		data: null

	render: ->
		React.createElement('ul', @_getAttr(), @_renderChildren())

	_getAttr: ->
		className: 'gtree-children'

	_renderChildren: ->
		React.createElement(gtree.Node, @state.data) if @state.data

	# --------------------------------
	# handle data

	setData: (data)->
		data = @curNode = @_initializeData(data)
		data.path = true
		@setState({data})

	_initializeData: (node, parent, index)->
		node.index = index
		node.parent = parent
		node.children = [] unless node.children

		node.children.map (child, index)=>
			@_initializeData(child, node, index)

		return node

	edit: ->
		body = window.prompt 'Input the body', @curNode.body
		if body
			@curNode.body = body
			@setState(data:@state.data)

	toggle: ->
		@curNode.collapsed = !@curNode.collapsed
		@setState(data:@state.data)

	# --------------------------------
	# travarser

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
			@curPath?.forEach (node, index)-> node.path = false

			@curNode.current = false
			next.current = true
			@curNode = next

			curPath = []
			pathNode = next
			while pathNode
				curPath.push(pathNode)
				pathNode.path = true
				pathNode = pathNode.parent
			@curPath = curPath

			@setState(data:@state.data)

	# --------------------------------
	# manipulations

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

window.gtree = {} unless window.gtree
window.gtree.Tree = Tree
