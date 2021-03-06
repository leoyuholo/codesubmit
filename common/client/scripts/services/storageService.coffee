app = angular.module 'codesubmit'

app.service 'storageService', (urlService) ->

	self = {}

	self.extractFolderNames = (fileNames) ->
		_.unique(_.map fileNames, (name) -> name.replace /\/(in|out|hint)?$/, '').sort()

	self.readZipFileNames = (zipFile, done) ->
		reader = new FileReader()

		reader.onload = (event) ->
			zip = new JSZip(event.target.result)

			done null, _.keys(zip.files).sort()

		reader.readAsArrayBuffer zipFile

	self.readZipFolderNames = (zipFile, done) ->
		self.readZipFileNames zipFile, (err, fileNames) ->
			return done err if err

			done null, self.extractFolderNames fileNames

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
