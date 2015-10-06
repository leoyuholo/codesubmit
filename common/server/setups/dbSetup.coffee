async = require 'async'
mongoose = require 'mongoose'
Grid = require 'gridfs-stream'
amqp = require 'amqplib/callback_api'

module.exports = ($) ->
	self = {}

	setupMongoose = (done) ->
		mongoose.connect "mongodb://#{$.config.mongodb.host}:#{$.config.mongodb.port}/#{$.config.mongodb.db}", done

	setupGridfs = (done) ->
		$.gridfs = Grid mongoose.connection.db, mongoose.mongo
		done null

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

	return self
