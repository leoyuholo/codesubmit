
module.exports = (grunt, options) ->
	config =
		admin:
			script: 'admin/server/app.coffee'
			options:
				watch: ['admin/server/', 'common/server/']
				extensions: ['coffee']
		student:
			script: 'student/server/app.coffee'
			options:
				watch: ['student/server/', 'common/server/']
				extensions: ['coffee']
		worker:
			script: 'worker/server/app.coffee'
			options:
				watch: ['worker/server/', 'common/server/']
				extensions: ['coffee']

	return config
