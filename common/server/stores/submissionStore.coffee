_ = require 'lodash'

module.exports = ($) ->
	self = {}

	Submission = $.models.Submission

	self.list = (condition, done) ->
		if _.isFunction condition
			done = condition
			condition = {}

		Submission.find condition, done

	self.findBySubId = (condition, done) ->
		Submission.findOne condition, done

	self.create = (submission, done) ->
		Submission.create submission, (err, submission) ->
			$.emitter.emit 'submissionUpdated', submission
			done err, submission

	self.update = (submission, done) ->
		Submission.update {subId: submission.subId}, submission, (err) ->
			$.emitter.emit 'submissionUpdated', submission
			done err

	self.updateResult = (subId, testCaseName, result, done) ->
		Submission.update {subId: subId, "results.testCaseName": testCaseName}, {$set: {"results.$": result}}, (err) ->
			$.emitter.emit 'resultUpdated', subId, testCaseName, result
			done err

	self.removeByAsgId = (asgId, done) ->
		Submission.remove {asgId: asgId}, done

	return self
