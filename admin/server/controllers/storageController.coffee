path = require 'path'

multer = require 'multer'

$ = require '../globals'

upload = multer {dest: path.join $.rootDir, 'storage/'}

router = $.express.Router()

router.get /^\/([\w_\/]+)/, (req, res, done) ->
	storageKey = req.params[0]

	return $.utils.onError done, new Error('Invalid storage key.') if !storageKey

	if req.query.infoOnly
		$.stores.storageStore.findByKey storageKey, (err, info) ->
			res.json
				success: true
				info:
					length: info.length
					uploadDate: info.uploadDate
					md5: info.md5
	else
		filename = req.query.filename
		res.setHeader 'Content-disposition', "attachment; filename=#{filename}" if filename
		$.stores.storageStore.readStream(storageKey).pipe res

router.post /^\/([\w_\/]+)/, upload.single('file'), (req, res, done) ->
	storageKey = req.params[0]
	filePath = req.file?.path

	return $.utils.onError done, new Error('Invalid storage key.') if !storageKey
	return $.utils.onError done, new Error('Invalid file.') if !filePath

	$.stores.storageStore.writeFromFs storageKey, filePath, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			key: req.params.key

module.exports = router
