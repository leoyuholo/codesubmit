
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

	return config
