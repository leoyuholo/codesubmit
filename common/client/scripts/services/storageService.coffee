app = angular.module 'codesubmit'

app.service 'storageService', (urlService) ->

	self = {}

	self.post = (key, file, done) ->
		payload = new FormData()
		payload.append 'file', file

		options =
			headers:
				'Content-Type': undefined

		urlService.post urlService.storage.post(key), payload, options, done

	self.findByKey = (key, done) ->
		urlService.get urlService.storage.findByKey(key), done

	return self
