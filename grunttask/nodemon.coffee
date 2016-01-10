fs = require 'fs'
path = require 'path'

module.exports = (grunt, options) ->
	config =
		options:
			execMap:
				coffee: 'node_modules/.bin/coffee'
		admin:
			script: 'admin/server/app.coffee'
			options:
				watch: ['admin/server/', 'common/server/', 'configs/']
		student:
			script: 'student/server/app.coffee'
			options:
				watch: ['student/server/', 'common/server/', 'configs/']
		worker:
			script: 'worker/server/app.coffee'
			options:
				watch: ['worker/server/', 'common/server/', 'configs/']

	return config
