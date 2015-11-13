_ = require 'lodash'

config =
	port: 8002
	logFile: "worker-#{Date.now()}.log"

module.exports = _.defaultsDeep config, require './commonConfig'
