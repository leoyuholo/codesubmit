
module.exports = ($) ->
	self = {}

	Submission = $.models.Submission

	self.list = (asgId, done) ->
		Submission.find {asgId: asgId}, done

	self.findBySubId = (subId, done) ->
		Submission.findOne {subId: subId}, done

	self.create = (submission, done) ->
		Submission.create submission, done

	self.update = (submission, done) ->
		Submission.update {subId: submission.subId}, submission, done

	return self
