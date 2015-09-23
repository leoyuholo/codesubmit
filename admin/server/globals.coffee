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
$.adminDir = path.join $.serverDir, '../'
$.rootDir = path.join $.adminDir, '../'

# express
$.express = express
$.app = express()
$.app.use bodyParser.json()
# $.app.use bodyParser.urlencoded {extended: true}

# configs
$.configs = requireAll path.join $.rootDir, 'configs'
$.config = $.configs.adminConfig

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

api.use '/user', $.controllers.userController

api.use (req, res, done) ->
	return done() if req.isAuthenticated()
	done new Error 'Unauthorized access.'

_.each $.controllers, (controller, name) ->
	api.use '/' + S(name).chompRight('Controller').s, controller if name != 'userController'

api.use (err, req, res, done) ->
	if err
		# console.log err.stack
		errMsg = ''
		if err.errors
			_.each err.errors, (e) ->
				errMsg += "\n#{e.message}"
		res.json
			success: false
			msg: errMsg || err.message

$.app.use express.static path.join $.adminDir, 'public'
$.app.use '/api', api
