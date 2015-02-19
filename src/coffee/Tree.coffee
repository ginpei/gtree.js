Tree = React.createClass
	getInitialState:->
		data: null
		path: []

	render: ->
		operator = @operator
		pathString = (@state.path.map (node, index) -> operator.pathString(node)).reverse().join(' - ')

		React.createElement('div', null,
			React.createElement('div', { className:'gtree-path' }, pathString)
			React.createElement('ul', { className:'gtree-children' }, React.createElement(gtree.Node, @state.data))
		)

	# --------------------------------
	# handle data

	setData: (data)->
		operator = @operator

		data = @curNode = @_initializeData(data)
		operator.current(data, true)
		operator.path(data, true)
		@setState({data, path:[data]})

	_initializeData: (node, parent, index)->
		node.index = index
		node.parent = parent
		node.children = [] unless node.children

		node.children.map (child, index)=>
			@_initializeData(child, node, index)

		return node

	edit: ->
		operator = @operator
		body = window.prompt 'Input the body', operator.body(@curNode)
		if body
			operator.body(@curNode, body)
			@setState(data:@state.data)

	toggle: ->
		operator = @operator
		operator.collapsed(@curNode, !operator.collapsed(@curNode))
		@setState(data:@state.data)

	# --------------------------------
	# travarser

	moveToParent: ->
		@_moveTo(@operator.parent(@curNode))

	moveToChild: ->
		@_moveTo(@operator.firstChild(@curNode))

	moveToPrev: ->
		@_moveTo(@operator.prev(@curNode))

	moveToNext: ->
		@_moveTo(@operator.next(@curNode))

	_moveTo: (next)->
		operator = @operator
		if next
			@_resetPath()

			operator.current(@curNode, false)
			operator.current(next, true)
			@curNode = next

			@_preparePath(next)
			@setState(data:@state.data, path:@state.path)

	_resetPath: ->
		operator = @operator
		@state.path.forEach (node, index)-> operator.path(node, false)

	_preparePath: (next)->
		operator = @operator

		curPath = @state.path
		curPath.splice(0)
		pathNode = next
		while pathNode
			curPath.push(pathNode)
			operator.path(pathNode, true)
			pathNode = operator.parent(pathNode)

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
