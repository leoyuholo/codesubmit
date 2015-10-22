_ = require 'lodash'

config =
	port: 8000
	sessionSecret: 'codeSubmit admin secret'
	sessionName: 'codesubmitadmin'
	redis:
		db: 1

module.exports = _.defaultsDeep config, require './commonConfig'
