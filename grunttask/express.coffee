
module.exports = (grunt, options) ->
	config =
		options:
			port: 9000
		livereload:
			options:
				bases: [__dirname + '/../admin/public']
				livereload: true

	return config
