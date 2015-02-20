Tree = React.createClass
	getDefaultProps: ->
		pathDelimiter: ' - '

	getInitialState:->
		data: null
		path: []

	render: ->
		operator = @operator

		path = React.createElement(gtree.Path,
			delimiter: @props.pathDelimiter
			dirs: (@state.path.map (node, index) -> operator.pathString(node)).reverse()
		)

		React.createElement('div', null,
			path
			React.createElement('ul', { className:'gtree-children' }, React.createElement(gtree.Node, @state.data))
		)

	# --------------------------------
	# handle data

	setData: (data)->
		data = @curNode = @_initializeData(data)
		data.current = true
		data.path = true
		data.renderBody = @props.renderBody
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
			@_resetPath()

			@curNode.current = false
			next.current = true
			@curNode = next

			@_preparePath(next)
			@setState(data:@state.data, path:@state.path)

	_resetPath: ->
		@state.path.forEach (node, index)-> node.path = false

	_preparePath: (next)->
		curPath = @state.path
		curPath.splice(0)
		pathNode = next
		while pathNode
			curPath.push(pathNode)
			pathNode.path = true
			pathNode = pathNode.parent

	# --------------------------------
	# manipulations

	append: (next)->
		unless next
			body = @_promptNew()
			if body
				next = @_initializeData({body})

		if next
			node = @curNode
			next.parent = node
			next.index = node.children.length
			node.children.push(next)
			@_moveTo(next)

	insert: (next, before)->
		unless next
			body = @_promptNew()
			if body
				next = @_initializeData({body})

		if next
			node = @curNode
			next.index = index = node.index + (if before then 0 else 1)
			next.parent = parent = node.parent

			bros = parent.children
			bros2 = bros.splice(index)
			bros.push(next)
			bros2.forEach (node, index)->
				node.index++
				bros.push(node)

			@_moveTo(next)

	insertBefore: ->
		@insert(null, true)

	_promptNew: ->
		window.prompt('Input the body for the new node')

	yunk: ->
		@yunkedNode = @curNode

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

			@yunkedNode = old

	paste: ->
		@insert(@_cloneNode(@yunkedNode)) if @yunkedNode

	pasteBefore: ->
		@insert(@_cloneNode(@yunkedNode), true) if @yunkedNode

	pasteChild: ->
		@append(@_cloneNode(@yunkedNode)) if @yunkedNode

	_cloneNode: (obj, parent)->
		cloned = {}

		for key of obj
			value = obj[key]
			if value instanceof Array
				clonedValue = value.map (node, index)=> @_cloneNode(node, obj)
			else if typeof value is 'object' and key isnt 'parent'
				clonedValue = @_cloneNode(value, cloned)
			else
				clonedValue = value
			cloned[key] = clonedValue

		cloned.children.forEach (node, index)-> node.parent = cloned

		cloned

window.gtree = {} unless window.gtree
window.gtree.Tree = Tree
