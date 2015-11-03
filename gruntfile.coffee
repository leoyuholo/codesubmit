loadGruntTasks = require 'load-grunt-tasks'
loadGruntConfigs = require 'load-grunt-configs'

module.exports = (grunt) ->
	options =
		config:
			src: 'grunttask/*.coffee'

	loadGruntTasks grunt
	grunt.initConfig loadGruntConfigs grunt, options

	grunt.loadNpmTasks 'grunt-contrib-jade'

	grunt.registerTask 'livereload:admin', ['jade:admin', 'replace:admin', 'concurrent:admin']
	grunt.registerTask 'livereload:student', ['jade:student', 'replace:student', 'concurrent:student']

	grunt.registerTask 'admin', ['livereload:admin']
	grunt.registerTask 'student', ['livereload:student']
	grunt.registerTask 'worker', ['nodemon:worker']

	grunt.registerTask 'html', ['jade:minify', 'htmlmin:html']

	grunt.registerTask 'default', ['livereload:admin']
