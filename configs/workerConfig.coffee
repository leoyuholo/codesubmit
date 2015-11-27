_ = require 'lodash'
moment = require 'moment'

config =
	port: _.random 50000, 51000
	logFile: "worker-#{moment().format('YYYYMMDD_HHmmss')}.log"

module.exports = _.defaultsDeep config, require './commonConfig'
