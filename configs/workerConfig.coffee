_ = require 'lodash'

config =
	port: 8002

module.exports = _.defaultsDeep config, require './commonConfig'
