shortid = require 'shortid'

module.exports = ($) ->
	self = {}

	self.generateId = () ->
		shortid.generate()

	self.generatePw = () ->
		shortid.generate()

	return self
