document.addEventListener 'DOMContentLoaded', (event)->
	manager = gtree.Manager()
	manager.init
		el: '#gtree'
		pathDelimiter: ' > '
		data:
			body:'Root'
			children: [
				{ body:'Child 1', children:[{ body:'1-1', children:[{ body:'1-1-1' }] }] }
				{ body:'Child 2', children:[{ body:'2-1' }, { body:'2-2' }] }
				{ body:'Child 3' }
			]
		renderBody: (props)->
			React.createElement('div', { className:'gtree-body' }, props.body)
		operator:
			_values: 'body'

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
