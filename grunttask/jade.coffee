
module.exports = (grunt, options) ->
	config =
		admin:
			options:
				pretty: true
			files:
				'admin/public/index.html': 'admin/client/index.jade'
		adminminify:
			files:
				'admin/public/index.html': 'admin/client/index.jade'
		student:
			options:
				pretty: true
			files:
				'student/public/index.html': 'student/client/index.jade'
		studentminify:
			files:
				'student/public/index.html': 'student/client/index.jade'

	return config
