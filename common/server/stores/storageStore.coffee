fs = require 'fs'

module.exports = ($) ->
	self = {}

	self.writeFromFs = (gridfsKey, filepath, done) ->
		$.gridfs.remove {filename: gridfsKey}, (err) ->
			fs.createReadStream(filepath)
				.pipe($.gridfs.createWriteStream {filename: gridfsKey})
				.on('error', done)
				.on 'finish', () ->
					done null

	self.readStream = (gridfsKey) ->
		$.gridfs.createReadStream {filename: gridfsKey}

	self.findByKey = (gridfsKey, done) ->
		$.gridfs.findOne {filename: gridfsKey}, done

	self.remove = (gridfsKey, done) ->
		$.gridfs.remove {filename: gridfsKey}, done

	return self
