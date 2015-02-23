document.addEventListener 'DOMContentLoaded', (event)->
	editorCallback = null;
	$editor = document.querySelector('#editor')
	$body = $editor.querySelector('[name=body]')

	$editor.addEventListener 'submit', (event)->
		event.preventDefault()
		editorCallback($body.value) if editorCallback

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
		editBody: (body, options, callback)->
			editorCallback = (body)->
				$editor.classList.add('is-hidden')
				editorCallback = null
				callback(body)
			$body.value = body
			$editor.classList.remove('is-hidden')
			$body.select()

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
