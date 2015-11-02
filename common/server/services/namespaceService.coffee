path = require 'path'

module.exports = ($) ->
	self = {}

	self.makeFsPath = (key, id...) ->
		path.join $.constants.namespaceConstants.fsNamespace[key], id...

	self.makeStorageKey = (key, id) ->
		"#{$.constants.namespaceConstants.storageNamespace[key]}/#{id}"

	return self
