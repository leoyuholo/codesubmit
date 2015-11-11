_ = require 'lodash'
async = require 'async'

module.exports = ($) ->
	self = {}

	self.resultUpdated = (subId, testCaseName, result) ->
		$.stores.mqStore.publish subId, result
	$.emitter.on 'resultUpdated', self.resultUpdated

	self.submissionUpdated = (submission) ->
		$.stores.mqStore.publish submission.subId, submission.results if submission.results
	$.emitter.on 'submissionUpdated', self.submissionUpdated

	self.resultRunning = (subId, testCaseName) ->
		runResult =
			testCaseName: testCaseName
			status: 'running'

		$.stores.submissionStore.updateResult subId, runResult.testCaseName, runResult, _.noop
	$.emitter.on 'resultRunning', self.resultRunning

	self.resultEvaluated = (subId, testCaseName, runResult) ->
		$.stores.submissionStore.updateResult subId, testCaseName, runResult, _.noop
	$.emitter.on 'resultEvaluated', self.resultEvaluated

	return self
