
module.exports = ($) ->
	self = {}

	self.push = (data, done) ->
		$.amqp.sendToQueue $.config.rabbitmq.queues.submission, new Buffer(JSON.stringify data), {persisten: true}

		done null

	self.worker = (worker) ->
		$.amqp.consume $.config.rabbitmq.queues.submission, (msg) ->
			worker (JSON.parse msg.content.toString()), (err) ->
				# unrecoverable error
				throw err if err

				# done
				# $.amqp.ack msg

	return self
