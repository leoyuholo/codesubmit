async = require 'async'
mongoose = require 'mongoose'
Grid = require 'gridfs-stream'

$ = require '../globals'

module.exports = self = {}

setupMongoose = (done) ->
	mongoose.connect "mongodb://#{$.config.mongodb.host}:#{$.config.mongodb.port}/#{$.config.mongodb.db}", done

setupGridfs = (done) ->
	# TODO: use same connection as mongoose
	conn = mongoose.createConnection "mongodb://#{$.config.mongodb.host}:#{$.config.mongodb.port}/#{$.config.mongodb.db}"
	conn.once 'open', () ->
		$.gridfs = Grid conn.db, mongoose.mongo
		done()

self.run = (done) ->
	async.series [
		setupMongoose
		setupGridfs
	], done
