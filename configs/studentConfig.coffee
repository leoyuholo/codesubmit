_ = require 'lodash'

config =
	port: 8001
	sessionSecret: 'codeSubmit student secret'
	sessionName: 'codesubmitstudent'
	redis:
		db: 2

module.exports = _.defaultsDeep config, require './commonConfig'
