path = require 'path'

multer = require 'multer'

module.exports = ($) ->
	self = {}

	self.get = () ->
		$.express.Router().get /^\/([-\w_\/]+)/, (req, res, done) ->
			storageKey = req.params[0]

			return $.utils.onError done, new Error('Invalid storage key.') if !storageKey

			if req.query.infoOnly
				$.stores.storageStore.findByKey storageKey, (err, fileInfo) ->
					return $.utils.onError done, err if err
					return $.utils.onError done, new Error('File not found.') if !fileInfo

					res.json
						success: true
						fileInfo:
							length: fileInfo.length
							uploadDate: fileInfo.uploadDate
							md5: fileInfo.md5
			else
				filename = req.query.filename
				res.setHeader 'Content-disposition', "attachment; filename=#{filename}" if filename
				$.stores.storageStore.readStream(storageKey).pipe res

	self.post = () ->
		$.express.Router().post /^\/([-\w_\/]+)/, multer({dest: path.join $.rootDir, 'storage/'}).single('file'), (req, res, done) ->
			storageKey = req.params[0]
			filePath = req.file?.path

			return $.utils.onError done, new Error('Invalid storage key.') if !storageKey
			return $.utils.onError done, new Error('Invalid file.') if !filePath

			$.stores.storageStore.writeFromFs storageKey, filePath, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					key: req.params.key

	return self
