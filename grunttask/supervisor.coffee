
module.exports = (grunt, options) ->
	config =
		admin:
			script: 'admin/server/app.coffee'
			options:
				watch: ['admin/server/']
				extensions: ['coffee']
		student:
			script: 'student/server/app.coffee'
			options:
				watch: ['student/server/']
				extensions: ['coffee']
		worker:
			script: 'worker/server/app.coffee'
			options:
				watch: ['worker/server/']
				extensions: ['coffee']

	return config
