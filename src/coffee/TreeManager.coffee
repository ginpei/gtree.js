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

	tree = React.render(React.createElement(gtree.Tree), el)
	tree.setData(options.data)

	@curTree = tree unless @curTree

	return tree

window.gtree = {} unless window.gtree
window.gtree.TreeManager = TreeManager
