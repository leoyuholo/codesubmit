$ = require '../globals'

module.exports = self = {}

self.run = (done) ->
	$.stores.mqStore.worker $.services.workerService.work
