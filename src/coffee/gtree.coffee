VK =
	h: 104
	j: 106
	k: 107
	l: 108

CLS =
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
				when VK.h then @moveToParent()
				when VK.k then @moveToPrev()
				when VK.j then @moveToNext()
				when VK.l then @moveToChild()

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
