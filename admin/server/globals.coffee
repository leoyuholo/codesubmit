path = require 'path'

express = require 'express'
bodyParser = require 'body-parser'
_requireAll = require 'require-all'
requireAll = (dir) ->
	_requireAll
		dirname: dir
		filter: /(.+)\.(coffee|js(on)?)$/

module.exports = $ = {}

$.express = express
$.app = express()
$.app.use bodyParser.json()

# dirs
$.serverDir = __dirname
$.adminDir = path.join $.serverDir, '../'
$.rootDir = path.join $.adminDir, '../'

# configs
$.configs = requireAll path.join $.rootDir, 'configs'
$.config = $.configs.adminConfig

# initialzation sequence is important
$.utils = requireAll path.join $.serverDir, 'utils'
$.models = requireAll path.join $.serverDir, 'models'
$.stores = requireAll path.join $.serverDir, 'stores'
$.services = requireAll path.join $.serverDir, 'services'
$.controllers = requireAll path.join $.serverDir, 'controllers'

# routes
api = $.express.Router()
api.use '/user', $.controllers.userController
api.use '/admin', $.controllers.adminController
api.use '/student', $.controllers.studentController

api.use (req, res, done) ->
	return done() if req.isAuthenticated()
	done new Error 'Unauthorized access.'

api.use (err, req, res, done) ->
	if err
		console.log err.stack
		res.json
			success: false
			msg: err.message

$.app.use express.static path.join $.adminDir, 'public'
$.app.use '/api', api
