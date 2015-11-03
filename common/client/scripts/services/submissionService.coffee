app = angular.module 'codesubmit'

app.service 'submissionService', (urlService) ->
	self = {}

	self.list = (asgId, done) ->
		urlService.get urlService.submission.list(asgId), done

	self.listMine = (asgId, done) ->
		urlService.get urlService.submission.listMine(asgId), done

	self.findBySubId = (subId, done) ->
		urlService.get urlService.submission.findBySubId(subId), done

	self.findMineBySubId = (subId, done) ->
		urlService.get urlService.submission.findMineBySubId(subId), done

	self.run = (asgId, code, input, output, done) ->
		payload =
			code: code
			input: input
			output: output

		urlService.post urlService.submission.run(asgId), payload, done

	self.submit = (asgId, code, done) ->
		payload =
			code: code

		urlService.post urlService.submission.submit(asgId), payload, done

	return self
