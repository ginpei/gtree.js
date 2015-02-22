Manager = (options)->
	if @ instanceof Manager
		return @constructor(options)
	else
		return new Manager(options)

Manager.prototype.constructor = (options)->
	document.addEventListener 'keypress', (event)=>
		tree = @curTree
		if tree
			executed = tree.onkey(event.keyCode)
			if executed
				event.preventDefault()

	return @

Manager.prototype.init = (options)->
	el = options.el
	if typeof el is 'string'
		el = document.querySelector(el)

	props =
		pathDelimiter: options.pathDelimiter
		renderBody: options.renderBody
		editBody: options.editBody

	tree = React.render(React.createElement(gtree.Tree, props), el)
	tree.operator = options.operator.initialize()
	tree.setData(options.data)

	@curTree = tree unless @curTree

	return tree

window.gtree = {} unless window.gtree
window.gtree.Manager = Manager
