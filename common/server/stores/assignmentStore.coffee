
module.exports = ($) ->

	Assignment = $.models.Assignment

	self = {}

	self.list = (done) ->
		Assignment.find {}, done

	self.findByAsgId = (asgId, done) ->
		Assignment.findOne {asgId: asgId}, done

	self.create = (assignment, done) ->
		Assignment.create assignment, done

	self.update = (assignment, done) ->
		Assignment.update {asgId: assignment.asgId}, assignment, done

	return self
