$ = require '../globals'

module.exports = self = {}

self.push = (data, done) ->
	$.amqp.sendToQueue $.config.rabbitmq.queues.submission, new Buffer(JSON.stringify data), {persisten: true}

	done null
