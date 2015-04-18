Manager = (options)->
	if @ instanceof Manager
		return @constructor(options)
	else
		return new Manager(options)

Manager.prototype.constructor = (options)->
	onkey = (event)=>
		tree = @curTree
		if tree
			command = window.keymapstring(event)
			executed = tree.onkey(command)
			if executed
				event.preventDefault()

	document.addEventListener('keydown', onkey)
	document.addEventListener('keypress', onkey)

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
	tree.operator = options.operator?.initialize?() or options.operator
	tree.setData(options.data)

	@curTree = tree unless @curTree

	return tree

window.gtree = {} unless window.gtree
window.gtree.Manager = Manager
