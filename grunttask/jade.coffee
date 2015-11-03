
module.exports = (grunt, options) ->
	config =
		minify:
			files:
				'admin/public/index.html': 'admin/client/index.jade'
				'student/public/index.html': 'student/client/index.jade'
		admin:
			options:
				pretty: true
			files:
				'admin/public/index.html': 'admin/client/index.jade'
		student:
			options:
				pretty: true
			files:
				'student/public/index.html': 'student/client/index.jade'

	return config
