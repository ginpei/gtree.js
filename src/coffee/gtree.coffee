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
			_values: 'current path body collapsed parent'

			initialize: ->
				@_values.split(' ').forEach (name, index)=>
					@[name] = (node, value)->
						if arguments.length < 2
							return node[name]
						else
							node[name] = value
							return @
				return @

			build: (data)-> data

			pathString: (node)-> node.body
			firstChild: (node)-> node.children?[0]
			prev: (node)-> node.parent?.children?[node.index-1]
			next: (node)-> node.parent?.children?[node.index+1]

			append: (node, child)-> node.children.push(child)
			insert: (parent, node, index)->
				bros = parent.children
				bros2 = bros.splice(index)
				bros.push(node)
				bros2.forEach (node, index)->
					node.index++
					bros.push(node)
			delete: (node)->
				children = node.parent.children
				children.splice(node.index, 1)
				children.map (node, index) -> node.index = index
