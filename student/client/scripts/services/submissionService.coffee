app = angular.module 'codesubmit-student'

app.service 'submissionService', (urlService) ->
	self = {}

	self.submit = (asgId, code, done) ->
		payload =
			code: code

		urlService.post urlService.submission.submit(asgId), payload, done

	return self
