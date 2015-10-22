
module.exports = (grunt, options) ->
	config =
		admin:
			tasks: ['nodemon:admin', 'watch:admin', 'watch:adminReload']
			options:
				logConcurrentOutput: true
		student:
			tasks: ['nodemon:student', 'watch:student', 'watch:studentReload']
			options:
				logConcurrentOutput: true

	return config
