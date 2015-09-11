
module.exports = (grunt, options) ->
	config =
		admin:
			options:
				pretty: true
			files:
				'admin/public/index.html': 'admin/client/index.jade'

	return config
