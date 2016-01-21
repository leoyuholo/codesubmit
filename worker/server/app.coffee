async = require 'async'

$ = require './globals'

registerWorker = (done) ->
	$.stores.mqStore.work $.services.workerService.worker
	done null

async.series [
	$.run.setup
	registerWorker
	$.run.server
], (err) ->
	return $.logger.log 'error', "error starting up codesubmit worker #{err.message}" if err
	$.logger.log 'info', "[#{$.app.get('env')}]codeSubmit worker listen on port #{$.config.port}"
