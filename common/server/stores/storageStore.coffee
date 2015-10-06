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

	self.readStream = (gridfsKey, done) ->
		$.gridfs.createReadStream {filename: gridfsKey}

	self.findByKey = (gridfsKey, done) ->
		$.gridfs.findOne {filename: gridfsKey}, done

	return self
