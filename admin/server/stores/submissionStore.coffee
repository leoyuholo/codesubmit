$ = require '../globals'

Submission = $.models.Submission

module.exports = self = {}

self.list = (asgId, done) ->
	Submission.find {asgId: asgId}, done

self.findBySubId = (subId, done) ->
	Submission.findOne {subId: subId}, done

self.create = (submission, done) ->
	Submission.create assignment, done

self.update = (submission, done) ->
	Submission.update {subId: assignment.subId}, assignment, done
