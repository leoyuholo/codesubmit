app = angular.module 'codesubmit'

app.service 'storageService', (urlService) ->

	self = {}

	self.readZipFileNames = (zipFile, done) ->
		reader = new FileReader()

		reader.onload = (event) ->
			zip = new JSZip(event.target.result)

			done null, _.keys(zip.files).sort()

		reader.readAsArrayBuffer zipFile

	self.readZipFolderNames = (zipFile, done) ->
		self.readZipFileNames zipFile, (err, fileNames) ->
			return done err if err

			folderNames = _.unique _.map fileNames, (name) -> name.replace /\/(in|out|hint)?$/, ''

			done null, folderNames.sort()

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
