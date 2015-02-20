TreeManager = (options)->
	if @ instanceof TreeManager
		return @constructor(options)
	else
		return new TreeManager(options)

TreeManager.prototype.VK =
	return: 13
	space: 32
	A: 65
	C: 67
	O: 79
	P: 80
	S: 83
	a: 97
	d: 100
	h: 104
	j: 106
	k: 107
	l: 108
	o: 111
	p: 112
	y: 121
	z: 122

TreeManager.prototype.constructor = (options)->
	document.addEventListener 'keypress', (event)=>
		tree = @curTree
		return unless tree
		VK = @VK
		switch event.keyCode
			when VK.return then tree.edit()
			when VK.space then tree.toggle()
			when VK.A then tree.pasteChild()
			when VK.C then tree.edit()
			when VK.O then tree.insertBefore()
			when VK.P then tree.pasteBefore()
			when VK.S then tree.edit()
			when VK.a then tree.append()
			when VK.d then tree.delete()
			when VK.h then tree.moveToParent()
			when VK.k then tree.moveToPrev()
			when VK.j then tree.moveToNext()
			when VK.l then tree.moveToChild()
			when VK.o then tree.insert()
			when VK.p then tree.paste()
			when VK.y then tree.yunk()
			when VK.z then tree.toggle()

	return @

TreeManager.prototype.init = (options)->
	el = options.el
	if typeof el is 'string'
		el = document.querySelector(el)

	props =
		pathDelimiter: options.pathDelimiter
		renderBody: options.renderBody

	tree = React.render(React.createElement(gtree.Tree, props), el)
	tree.operator = options.operator.initialize()
	tree.setData(options.data)

	@curTree = tree unless @curTree

	return tree

window.gtree = {} unless window.gtree
window.gtree.TreeManager = TreeManager
