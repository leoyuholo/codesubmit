
module.exports = ($) ->
	self = {}

	self.list = (condition, done) ->
		$.stores.submissionStore.list condition, (err, submissions) ->
			return $.utils.onError done, err if err

			done null, submissions.map $.models.Submission.envelop

	self.findBySubId = (condition, done) ->
		$.stores.submissionStore.findBySubId condition, (err, submission) ->
			return $.utils.onError done, err if err

			done null, $.models.Submission.envelop submission

	self.submit = (student, asgId, code, done) ->
		submission =
			subId: $.utils.rng.generateId()
			asgId: asgId
			email: student.email
			submitDt: new Date()
			code: code

		$.stores.submissionStore.create submission, (err, submission) ->
			return $.utils.onError done, err if err

			$.stores.mqStore.push submission, (err) ->
				return $.utils.onError done, err if err

				done null, $.models.Submission.envelop submission

	return self
