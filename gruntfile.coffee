loadGruntTasks = require 'load-grunt-tasks'
loadGruntConfigs = require 'load-grunt-configs'

module.exports = (grunt) ->
	options =
		config:
			src: 'grunttask/*.coffee'

	loadGruntTasks grunt
	grunt.initConfig loadGruntConfigs grunt, options

	grunt.loadNpmTasks 'grunt-contrib-jade'

	grunt.registerTask 'default', ['jade:admin', 'express:livereload', 'watch:livereload']
