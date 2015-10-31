fse = require 'fs-extra'

module.exports = ($) ->
	self = {}

	setupDirectories = (done) ->
		fse.ensureDir $.constants.namespaceConstants.fsNamespace.testCase, done

	self.run = (done) ->
		setupDirectories done

	return self
