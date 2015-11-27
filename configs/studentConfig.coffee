_ = require 'lodash'
moment = require 'moment'

config =
	port: 8001
	sessionSecret: 'codeSubmit student secret'
	sessionName: 'codesubmitstudent'
	redis:
		db: 2
	logFile: "student-#{moment().format('YYYYMMDD_HHmmss')}.log"

module.exports = _.defaultsDeep config, require './commonConfig'
