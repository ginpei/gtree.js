VK =
	h: 104
	j: 106
	k: 107
	l: 108

CLS =
	current: 'gtree-current'

gtree =
	start: ->
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

window.gtree = gtree

$ -> gtree.start()
