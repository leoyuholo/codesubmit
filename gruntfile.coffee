loadGruntTasks = require 'load-grunt-tasks'
loadGruntConfigs = require 'load-grunt-configs'

module.exports = (grunt) ->
	options =
		config:
			src: 'grunttask/*.coffee'

	loadGruntTasks grunt
	grunt.initConfig loadGruntConfigs grunt, options

	grunt.registerTask 'livereload:admin', ['jade:admin', 'replace:admin', 'concurrent:admin']
	grunt.registerTask 'livereload:student', ['jade:student', 'replace:student', 'concurrent:student']
	grunt.registerTask 'livereload:all', ['jade:admin', 'jade:student', 'replace:admin', 'replace:student', 'concurrent:all']

	grunt.registerTask 'admin', ['livereload:admin']
	grunt.registerTask 'student', ['livereload:student']
	grunt.registerTask 'worker', ['nodemon:worker']
	grunt.registerTask 'all', ['livereload:all']

	grunt.registerTask 'html', ['jade:minify', 'htmlmin:html', 'curl-dir']

	grunt.registerTask 'default', ['livereload:admin']
