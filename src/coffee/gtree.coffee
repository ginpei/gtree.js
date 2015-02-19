document.addEventListener 'DOMContentLoaded', (event)->
	manager = gtree.TreeManager()
	manager.init
		el: '#gtree'
		data:
			body:'Root'
			children: [
				{ body:'Child 1', children:[{ body:'1-1' }] }
				{ body:'Child 2' }
				{ body:'Child 3' }
			]
		operator:
			current: (node, value)->
				if arguments.length < 2
					return node.current
				else
					node.current = value
					return @

			path: (node, value)->
				if arguments.length < 2
					return node.path
				else
					node.path = value
					return @

			body: (node, value)->
				if arguments.length < 2
					return node.body
				else
					node.body = value
					return @

			collapsed: (node, value)->
				if arguments.length < 2
					return node.collapsed
				else
					node.collapsed = value
					return @

			pathString: (node)->
				return node.body
