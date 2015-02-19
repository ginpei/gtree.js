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
			values: 'current path body collapsed parent'

			initialize: ->
				@values.split(' ').forEach (name, index)=>
					@[name] = (node, value)->
						if arguments.length < 2
							return node[name]
						else
							node[name] = value
							return @
				return @

			pathString: (node)-> return node.body
			firstChild: (node)-> node.children?[0]
			prev: (node)-> node.parent?.children?[node.index-1]
			next: (node)-> node.parent?.children?[node.index+1]
