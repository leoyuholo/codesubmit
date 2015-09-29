$ = require '../globals'

module.exports = self = {}

self.worker = (worker) ->
	$.amqp.consume $.config.rabbitmq.queues.submission, (msg) ->
		worker (JSON.parse msg.content.toString()), (err) ->
			# unrecoverable error
			throw err if err

			# done
			$.amqp.ack msg
