$ = require '../globals'

Submission = $.models.Submission

module.exports = self = {}

self.create = (submission, done) ->
	Submission.create submission, done
