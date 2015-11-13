_ = require 'lodash'

config =
	port: 8001
	sessionSecret: 'codeSubmit student secret'
	sessionName: 'codesubmitstudent'
	redis:
		db: 2
	logFile: "student-#{Date.now()}.log"

module.exports = _.defaultsDeep config, require './commonConfig'
