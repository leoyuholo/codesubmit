
module.exports = (grunt, options) ->
	config =
		admin:
			tasks: ['supervisor:admin', 'watch:admin']
			options:
				logConcurrentOutput: true
		student:
			tasks: ['supervisor:student', 'watch:student']
			options:
				logConcurrentOutput: true

	return config
