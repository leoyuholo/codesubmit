
module.exports = (grunt, options) ->
	config =
		all:
			tasks: ['concurrent:admin', 'concurrent:student', 'nodemon:worker']
			options:
				logConcurrentOutput: true
				limit: 10
		admin:
			tasks: ['nodemon:admin', 'watch:admin', 'watch:adminReload']
			options:
				logConcurrentOutput: true
		student:
			tasks: ['nodemon:student', 'watch:student', 'watch:studentReload']
			options:
				logConcurrentOutput: true

	return config
