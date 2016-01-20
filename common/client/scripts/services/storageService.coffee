app = angular.module 'codesubmit'

app.service 'storageService', (urlService) ->

	self = {}

	self.readZipFolderNames = (zipFile, done) ->
		reader = new FileReader()

		reader.onload = (event) ->
			zip = new JSZip(event.target.result)

			folderNames = _.filter _.keys(zip.files), _.bind RegExp().test, /[^\/]+\/$/

			folderNames = _.map folderNames, (name) -> name.replace /\/$/, ''

			done null, folderNames.sort()

		reader.readAsArrayBuffer zipFile

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
