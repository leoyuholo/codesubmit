
module.exports = (grunt, options) ->
	config =
		admin:
			script: 'admin/server/app.coffee'
			options:
				watch: ['admin/server']
				extensions: ['coffee']

	return config
