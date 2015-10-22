path = require 'path'

module.exports = $ = {}

# dirs
$.serverDir = __dirname
$.adminDir = path.join $.serverDir, '../'
$.rootDir = path.join $.adminDir, '../'
$.commonDir = path.join $.rootDir, 'common'

# configs
$.config = require path.join $.rootDir, 'configs', 'adminConfig'

# init common components
$ = require(path.join $.commonDir, 'server', 'globals')($)
# init controllers
$.controllers = $.utils.routerHelper.makeControllers
	exclude:
		statusController: '*'
$.controllers.userController = $.utils.routerHelper.makeUserController $.stores.adminStore

# routes
$.app.use $.express.static path.join $.adminDir, 'public'
$.app.use '/api', $.utils.routerHelper.makeApi()
