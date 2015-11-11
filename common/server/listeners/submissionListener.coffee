_ = require 'lodash'
async = require 'async'

module.exports = ($) ->
	self = {}

	self.submissionUpdated = (submission) ->
		$.services.submissionService.updateScoreStats submission.subId, _.noop
	$.emitter.on 'submissionUpdated', self.submissionUpdated

	self.submissionRunning = (subId) ->
		newSubmission =
			subId: subId
			status: 'running'

		$.stores.submissionStore.update newSubmission, _.noop
	$.emitter.on 'submissionRunning', self.submissionRunning

	self.submissionError = (subId, errorMessage, runResults) ->
		newSubmission =
			subId: subId
			status: 'error'
			evaluateDt: new Date()
			errorMessage: 'Server Error'
			score: 0

		$.stores.submissionStore.update newSubmission, _.noop
	$.emitter.on 'submissionError', self.submissionError

	self.submissionEvaluated = (subId, runResults) ->
		newSubmission =
			subId: subId
			status: 'evaluated'
			evaluateDt: new Date()
			results: runResults
			score: _.filter(runResults, 'correct').length

		$.stores.submissionStore.update newSubmission, _.noop
	$.emitter.on 'submissionEvaluated', self.submissionEvaluated

	return self
