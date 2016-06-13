_ = require 'lodash'
moment = require 'moment'

config =
	port: 8000
	sessionSecret: 'codeSubmit admin secret'
	sessionName: 'codesubmitadmin'
	logFile: "admin-#{moment().format('YYYYMMDD_HHmmss')}.log"

module.exports = _.defaultsDeep config, require './commonConfig'
