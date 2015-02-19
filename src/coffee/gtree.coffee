$ ->
	manager = gtree.TreeManager()
	manager.init
		el: '#gtree'
		data:
			body:'Root'
			current: true
			children: [
				{ body:'Child 1', children:[{ body:'1-1' }] }
				{ body:'Child 2' }
				{ body:'Child 3' }
			]
