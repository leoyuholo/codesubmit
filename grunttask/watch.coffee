
module.exports = (grunt, options) ->
	config =
		options:
			spawn: false
		admin:
			options:
				livereload: grunt.option('livereload') || 35729
			files: ['admin/client/**', 'admin/server/**']
			tasks: ['jade:admin', 'replace:admin']
		student:
			options:
				livereload: grunt.option('livereload') || 35729
			files: ['student/client/**', 'student/server/**']
			tasks: ['jade:student', 'replace:student']

	return config
