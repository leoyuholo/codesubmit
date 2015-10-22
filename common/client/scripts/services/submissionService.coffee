app = angular.module 'codesubmit'

app.service 'submissionService', (urlService) ->
	self = {}

	self.list = (asgId, done) ->
		urlService.get urlService.submission.list(asgId), done

	self.listMine = (asgId, done) ->
		urlService.get urlService.submission.listMine(asgId), done

	self.findMineBySubId = (subId, done) ->
		urlService.get urlService.submission.findMineBySubId(subId), done

	self.submit = (asgId, code, done) ->
		payload =
			code: code

		urlService.post urlService.submission.submit(asgId), payload, done

	return self
