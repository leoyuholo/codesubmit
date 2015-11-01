path = require 'path'

_ = require 'lodash'
express = require 'express'
bodyParser = require 'body-parser'
_requireAll = require 'require-all'
requireAll = (dir, injections) ->
	_requireAll
		dirname: dir
		filter: /(.+)\.(coffee|js(on)?)$/
		resolve: (exports) ->
			if _.isFunction exports then exports injections else exports

module.exports = ($) ->

	# express
	$.express = express
	$.app = express()
	$.app.use bodyParser.json()
	# $.app.use bodyParser.urlencoded {extended: true}

	# initialzation sequence is important
	[
		'constants'
		'utils'
		'models'
		'stores'
		'services'
		'setups'
		'controllerTemplates'
	].forEach (component) ->
		$[component] = requireAll path.join(__dirname, component), $

	$.utils.requireAll = requireAll

	return $