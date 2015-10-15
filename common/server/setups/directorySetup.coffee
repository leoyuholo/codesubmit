fse = require 'fs-extra'

module.exports = ($) ->
	self = {}

	setupDirectories = (done) ->
		fse.ensureDir '/submission/worker/sandboxconfig', done

	self.run = (done) ->
		setupDirectories done

	return self
