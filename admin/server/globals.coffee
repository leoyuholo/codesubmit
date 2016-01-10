path = require 'path'

module.exports = $ = {}

# dirs
$.serverDir = __dirname
$.adminDir = path.join $.serverDir, '../'
$.rootDir = path.join $.adminDir, '../'
$.commonDir = path.join $.rootDir, 'common'
$.publicDir = path.join $.adminDir, 'public'
$.commonPublicDir = path.join $.adminDir, 'public'

# configs
$.config = require path.join $.rootDir, 'configs', 'adminConfig'

# env
$.env =
	admin: true

# init common components
$ = require(path.join $.commonDir, 'server', 'globals')($)
# init controllers
$.controllers = $.utils.routerHelper.makeControllers
	exclude:
		statusController: '*'
		assignmentController: 'listpublishedwithmystats'
$.controllers.assignmentController.use $.controllerTemplates.assignmentController.listwithmystats('/listpublishedwithmystats')
$.controllers.userController = $.utils.routerHelper.makeUserController $.stores.adminStore

# routes
$.app.use $.express.static $.publicDir
$.app.use '/common', $.express.static $.commonPublicDir
$.app.use '/api', $.utils.routerHelper.makeApi()
