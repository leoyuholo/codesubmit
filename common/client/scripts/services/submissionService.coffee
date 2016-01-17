app = angular.module 'codesubmit'

app.service 'submissionService', (urlService) ->
	self = {}

	self.listScoreStats = (done) ->
		urlService.get urlService.submission.listScoreStats(), done

	self.listByAsgId = (asgId, done) ->
		urlService.get urlService.submission.listByAsgId(asgId), done

	self.listByEmail = (email, done) ->
		urlService.get urlService.submission.listByEmail(email), done

	self.listByAsgIdAndEmail = (asgId, email, done) ->
		urlService.get urlService.submission.listByAsgIdAndEmail(asgId, email), done

	self.listMineByAsgId = (asgId, done) ->
		urlService.get urlService.submission.listMineByAsgId(asgId), done

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
