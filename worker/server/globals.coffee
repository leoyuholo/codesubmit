path = require 'path'

_ = require 'lodash'
express = require 'express'
bodyParser = require 'body-parser'
_S = require 'string'
S = (s) -> _S(s || '')
_requireAll = require 'require-all'
requireAll = (dir) ->
	_requireAll
		dirname: dir
		filter: /(.+)\.(coffee|js(on)?)$/

module.exports = $ = {}

# dirs
$.serverDir = __dirname
$.workerDir = path.join $.serverDir, '../'
$.rootDir = path.join $.workerDir, '../'

# express
$.express = express
$.app = express()
$.app.use bodyParser.json()
# $.app.use bodyParser.urlencoded {extended: true}

# configs
$.config = require path.join $.rootDir, 'configs', 'workerConfig'

# initialzation sequence is important
[
	'utils'
	'models'
	'stores'
	'services'
	'setups'
	'controllers'
].forEach (component) ->
	$[component] = requireAll path.join $.serverDir, component

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
