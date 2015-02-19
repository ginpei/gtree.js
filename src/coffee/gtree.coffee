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
			_values: 'current path body collapsed'

			initialize: ->
				@_values.split(' ').forEach (name, index)=>
					@[name] = (node, value)->
						if arguments.length < 2
							return node[name]
						else
							node[name] = value
							return @
				return @

			pathString: (node)-> node.body
