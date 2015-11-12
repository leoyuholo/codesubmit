path = require 'path'
events = require 'events'

_ = require 'lodash'
express = require 'express'
bodyParser = require 'body-parser'
winston = require 'winston'
_requireAll = require 'require-all'
requireAll = (dir, injections) ->
	_requireAll
		dirname: dir
		filter: /(.+)\.(coffee|js(on)?)$/
		resolve: (exports) ->
			if _.isFunction exports then exports injections else exports

module.exports = ($) ->

	# emitters
	$.emitter = new events.EventEmitter()

	# express
	$.express = express
	$.app = express()
	$.app.use bodyParser.json {limit: '1000kb'}
	# $.app.use bodyParser.urlencoded {extended: true}

	$.logger = new winston.Logger(
		transports: [
			new (winston.transports.Console)({level: 'verbose', colorize: true})
			new (winston.transports.File)({filename: $.config.logfile})
		]
	)

	# initialzation sequence is important
	[
		'constants'
		'utils'
		'models'
		'stores'
		'services'
		'setups'
		'controllerTemplates'
		'listeners'
	].forEach (component) ->
		$[component] = requireAll path.join(__dirname, component), $

	$.utils.requireAll = requireAll

	return $
