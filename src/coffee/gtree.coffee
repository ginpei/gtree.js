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
		root = new gtree.Node data: body: 'Root'
		root.render()
		root.$el.appendTo('#gtree')

		child1 = (new gtree.Node data: body: 'Child 1').render()
		root.append(child1)
		child2 = (new gtree.Node data: body: 'Child 2').render()
		root.append(child2)
		child3 = (new gtree.Node data: body: 'Child 3').render()
		root.append(child3)

		child1_1 = (new gtree.Node data: {body: '1-1'}).render()
		child1.append(child1_1)

		@$curNode = $('#gtree .gtree-node:first')
		@$curNode.addClass(CLS.current)

		$(document).on 'keypress', (event)=>
			switch event.keyCode
				when VK.a then @append()
				when VK.d then @delete()
				when VK.h then @moveToParent()
				when VK.k then @moveToPrev()
				when VK.j then @moveToNext()
				when VK.l then @moveToChild()
				when VK.o then @insert()
				when VK.z then @toggle()
				when VK.C then @edit()
				when VK.O then @insertBefore()
				when VK.S then @edit()
				when VK.return then @edit()
				when VK.space then @toggle()

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

window.gtree = gtree

$ -> gtree.start()
