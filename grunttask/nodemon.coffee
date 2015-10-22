fs = require 'fs'
path = require 'path'

module.exports = (grunt, options) ->
	config =
		admin:
			script: 'admin/server/app.coffee'
			options:
				watch: ['admin/server/', 'common/server/', 'configs/']
				callback: (nodemon) ->
					nodemon.on 'restart', () ->
						setTimeout ( () ->
							fs.writeFileSync path.join(__dirname, '..', 'admin', 'public', '.rebooted'), 'rebooted'
						), 1000
		student:
			script: 'student/server/app.coffee'
			options:
				watch: ['student/server/', 'common/server/', 'configs/']
				callback: (nodemon) ->
					nodemon.on 'restart', () ->
						setTimeout ( () ->
							fs.writeFileSync path.join(__dirname, '..', 'student', 'public', '.rebooted'), 'rebooted'
						), 1000
		worker:
			script: 'worker/server/app.coffee'
			options:
				watch: ['worker/server/', 'common/server/', 'configs/']

	return config
