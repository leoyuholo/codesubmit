path = require 'path'

_ = require 'lodash'
express = require 'express'
bodyParser = require 'body-parser'
_S = require 'string'
S = (s) -> _S(s || '')
_requireAll = require 'require-all'
requireAll = (dir, injections) ->
	_requireAll
		dirname: dir
		filter: /(.+)\.(coffee|js(on)?)$/
		resolve: (exports) ->
			if _.isFunction exports then exports injections else exports

module.exports = $ = {}

# dirs
$.serverDir = __dirname
$.workerDir = path.join $.serverDir, '../'
$.rootDir = path.join $.workerDir, '../'
$.commonDir = path.join $.rootDir, 'common'

# express
$.express = express
$.app = express()
$.app.use bodyParser.json()
# $.app.use bodyParser.urlencoded {extended: true}

# configs
$.config = require path.join $.rootDir, 'configs', 'workerConfig'

# initialzation sequence is important
[
	{name: 'constants', path: path.join $.commonDir, 'server', 'constants'}
	{name: 'utils', path: path.join $.commonDir, 'server', 'utils'}
	{name: 'models', path: path.join $.commonDir, 'server', 'models'}
	{name: 'stores', path: path.join $.commonDir, 'server', 'stores'}
	{name: 'services', path: path.join $.commonDir, 'server', 'services'}
	{name: 'setups', path: path.join $.commonDir, 'server', 'setups'}
	{name: 'controllers', path: path.join $.serverDir, 'controllers'}
].forEach (component) ->
	$[component.name] = requireAll component.path, $

# routes
api = $.express.Router()

_.each $.controllers, (controller, name) ->
	api.use '/' + S(name).chompRight('Controller').s, controller

api.use (err, req, res, done) ->
	if err
		console.log err.stack
		errMsg = ''
		if err.errors
			_.each err.errors, (e) ->
				errMsg += "\n#{e.message}"
		res.json
			success: false
			msg: errMsg || err.message

$.app.use '/api', api
