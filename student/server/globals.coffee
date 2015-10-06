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
$.studentDir = path.join $.serverDir, '../'
$.rootDir = path.join $.studentDir, '../'
$.commonDir = path.join $.rootDir, 'common'

# express
$.express = express
$.app = express()
$.app.use bodyParser.json()
# $.app.use bodyParser.urlencoded {extended: true}

# configs
$.config = require path.join $.rootDir, 'configs', 'studentConfig'

# initialzation sequence is important
[
	['utils', path.join $.commonDir, 'server', 'utils']
	['models', path.join $.commonDir, 'server', 'models']
	['stores', path.join $.commonDir, 'server', 'stores']
	['services', path.join $.commonDir, 'server', 'services']
	['setups', path.join $.commonDir, 'server', 'setups']
	['controllers', path.join $.serverDir, 'controllers']
].forEach ([componentName, componentPath]) ->
	$[componentName] = requireAll componentPath, $

# routes
api = $.express.Router()

# allow unauthorized access to api/user
api.use '/user', $.controllers.userController

# otherwise, require authentication
api.use (req, res, done) ->
	return done() if req.isAuthenticated()
	done new Error 'Unauthorized access.'

_.each $.controllers, (controller, name) ->
	api.use '/' + S(name).chompRight('Controller').s, controller if name != 'userController'

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

$.app.use express.static path.join $.studentDir, 'public'
$.app.use '/api', api
