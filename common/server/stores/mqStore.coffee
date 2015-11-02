_ = require 'lodash'

module.exports = ($) ->
	self = {}

	self.push = (data, done) ->
		$.amqp.sendToQueue $.config.rabbitmq.queues.submission, new Buffer(JSON.stringify data), {persisten: true}

		done null

	envelop = (data, lastFlag) ->
		lastFlag = true if lastFlag == undefined
		new Buffer(JSON.stringify {data: data, lastFlag: lastFlag})

	self.worker = (worker) ->
		$.amqp.consume $.config.rabbitmq.queues.submission, ( (msg) ->
			notify = (data) ->
				if msg.properties.replyTo
					$.amqp.sendToQueue msg.properties.replyTo, envelop(data, false), {correlationId: msg.properties.correlationId}

			worker (JSON.parse msg.content.toString()), notify, (err, result) ->
				$.utils.onError _.noop, err if err

				if msg.properties.replyTo
					$.amqp.sendToQueue msg.properties.replyTo, envelop(result, true), {correlationId: msg.properties.correlationId}

				# done
				$.amqp.ack msg
		), {noAck: false}

	self.rpc = (data, notify, done) ->
		$.amqp.assertQueue '', {exclusive: true}, (err, q) ->
			corr = $.utils.rng.generateUuid()

			$.amqp.consume q.queue, ( (msg) ->
				if msg.properties.correlationId == corr
					content = JSON.parse msg.content.toString()
					if content.lastFlag
						done null, content.data
					else
						notify content.data
			), {noAck: true}

			$.amqp.sendToQueue $.config.rabbitmq.queues.submission, new Buffer(JSON.stringify data), {correlationId: corr, replyTo: q.queue}

	return self
