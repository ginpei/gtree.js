document.addEventListener 'DOMContentLoaded', (event)->
	manager = window.gtree.Manager()
	manager.init
		el: '#tree'
		data:
			body:'Root'
		operator:
			pathString: (node)-> node.body
