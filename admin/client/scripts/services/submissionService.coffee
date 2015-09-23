app = angular.module 'codesubmit-admin'

app.service 'submissionService', (urlService) ->
	self = {}

	self.list = (asgId, done) ->
		urlService.get urlService.submission.list(asgId), done

	return self
