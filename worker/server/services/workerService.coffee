$ = require '../globals'

module.exports = self = {}

self.work = (submission, done) ->
	$.services.statusService.startJob submission, (err) ->
		console.log submission.code
		# TODO: call sandbox
		result = {}
		$.services.statusService.finishJob submission, result, (err) ->
			done null
