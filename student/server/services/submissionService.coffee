$ = require '../globals'

module.exports = self = {}

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

			done null, submission
