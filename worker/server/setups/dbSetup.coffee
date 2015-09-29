async = require 'async'
mongoose = require 'mongoose'
Grid = require 'gridfs-stream'
amqp = require 'amqplib/callback_api'

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

setupRabbitMQ = (done) ->
	rabbitmq = $.config.rabbitmq

	amqp.connect "amqp://#{$.config.rabbitmq.host}:#{$.config.rabbitmq.port}", (err, conn) ->
		return $.utils.onError done, err if err

		conn.createChannel (err, ch) ->
			return $.utils.onError done, err if err

			$.amqp = ch

			queues = rabbitmq.queues
			ch.assertQueue queues.submission, {durable: true}
			ch.prefetch 1

			done null

self.run = (done) ->
	async.series [
		setupMongoose
		setupGridfs
		setupRabbitMQ
	], done
