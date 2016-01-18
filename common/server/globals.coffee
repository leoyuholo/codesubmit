path = require 'path'
events = require 'events'

_ = require 'lodash'
async = require 'async'
express = require 'express'
bodyParser = require 'body-parser'
compression = require 'compression'
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
	$.app.use compression()

	# env
	$.env = $.env || {}
	$.env.development = $.app.get('env') == 'development'
	$.env.production = $.app.get('env') == 'production'

	$.logger = new winston.Logger(
		transports: [
			new (winston.transports.Console)({level: 'verbose', colorize: true})
			new (winston.transports.File)({filename: path.join $.config.logDir, $.config.logFile})
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

	# methods
	$.run = {}
	$.run.setup = (done) ->
		process.nextTick () ->
			async.eachSeries $.setups, ( (setup, done) ->
				setup.run done
			), done
	$.run.server = (done) ->
		$.app.listen $.config.port, (err) ->
			return $.utils.onError done, err if err

			$.emitter.emit 'serverStarted'

			done null

	return $
