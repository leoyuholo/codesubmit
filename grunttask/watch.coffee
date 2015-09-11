
module.exports = (grunt, options) ->
	config =
		options:
			spawn: false
		livereload:
			options:
				livereload: true
			files: ['admin/client/**']
			tasks: ['jade:admin']

	return config
