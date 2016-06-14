path = require 'path'

module.exports = ($) ->
	self = {}

	self.id = $.utils.rng.generateId()

	self.makeFsPath = (key, id...) ->
		path.join $.constants.namespaceConstants.fsNamespace[key], self.id, id...

	self.makeStorageKey = (key, id) ->
		"#{$.constants.namespaceConstants.storageNamespace[key]}/#{id}"

	return self
