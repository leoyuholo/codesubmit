
module.exports = (grunt, options) ->
	config =
		options:
			spawn: false
			debounceDelay: 2000
		admin:
			files: ['admin/client/**', 'common/client/**']
			tasks: ['jade:admin', 'replace:admin']
		adminReload:
			options:
				livereload: grunt.option('livereload') || 35729
			files: ['admin/public/**', 'admin/public/.rebooted']
		student:
			files: ['student/client/**', 'common/client/**']
			tasks: ['jade:student', 'replace:student']
		studentReload:
			options:
				livereload: grunt.option('livereload') || 35729
			files: ['student/public/**', 'student/public/.rebooted']

	return config
