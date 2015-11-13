_ = require 'lodash'

config =
	port: 8000
	sessionSecret: 'codeSubmit admin secret'
	sessionName: 'codesubmitadmin'
	redis:
		db: 1
	logFile: "admin-#{Date.now()}.log"

module.exports = _.defaultsDeep config, require './commonConfig'
