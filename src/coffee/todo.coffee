document.addEventListener 'DOMContentLoaded', (event)->
	manager = window.gtree.Manager()
	manager.init
		el: '#tree'
		data:
			body:'MyTasks'
		operator:
			pathString: (node)-> node.body
			initialize: ()->
				console.log 'operator.initialize'
				return @
