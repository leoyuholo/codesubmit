$ = require '../globals'

module.exports = self = {}

self.list = (asgId, done) ->
	$.stores.submissionStore.list asgId, (err, submissions) ->
		return $.utils.onError done, err if err

		done null, submissions.map $.models.Submission.envelop
