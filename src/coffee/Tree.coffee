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
		operator = @operator
		body = @_promptNew()
		if body
			cur = @curNode
			next = @_initializeData(operator.build({body}), cur, cur.children.length)
			operator.append(cur, next)
			@_moveTo(next)

	insert: (_back)->
		operator = @operator
		body = @_promptNew()
		if body
			next = @_initializeData(operator.build({body}))
			operator.insert(@curNode, next, _back)
			@_moveTo(next)

	insertBefore: ->
		@insert(true)

	_promptNew: ->
		window.prompt('Input the body for the new node')

	delete: ->
		operator = @operator

		old = @curNode
		@moveToNext()
		if @curNode is old
			@moveToPrev()
			if @curNode is old
				@moveToParent()

		if @curNode isnt old
			operator.delete(old)
			@setState(data:@state.data)

window.gtree = {} unless window.gtree
window.gtree.Tree = Tree
