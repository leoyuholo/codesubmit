shortid = require 'shortid'
uuid = require 'node-uuid'

module.exports = ($) ->
	self = {}

	self.generateUuid = () ->
		uuid.v4()

	self.generateId = () ->
		shortid.generate()

	self.generatePw = () ->
		shortid.generate()

	return self
