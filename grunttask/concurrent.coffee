
module.exports = (grunt, options) ->
	config =
		admin:
			tasks: ['supervisor:admin', 'watch:admin']
			options:
				logConcurrentOutput: true

	return config
