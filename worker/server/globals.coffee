path = require 'path'

_ = require 'lodash'

module.exports = $ = {}

# dirs
$.serverDir = __dirname
$.workerDir = path.join $.serverDir, '../'
$.rootDir = path.join $.workerDir, '../'
$.commonDir = path.join $.rootDir, 'common'

# configs
$.config = require path.join $.rootDir, 'configs', 'workerConfig'

# env
$.env =
	worker: true

# init common components
$ = require(path.join $.commonDir, 'server', 'globals')($)
# init controllers
$.controllers = $.utils.routerHelper.makeControllers
	include:
		statusController: '*'

# routes
$.app.use '/api', $.utils.routerHelper.makeApi()
