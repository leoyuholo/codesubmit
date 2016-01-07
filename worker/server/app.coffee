async = require 'async'

$ = require './globals'

runSetups = (done) ->
	process.nextTick () ->
		async.eachSeries $.setups, ( (setup, done) ->
			setup.run done
		), done

registerWorker = (done) ->
	$.stores.mqStore.work $.services.workerService.worker
	done null

startServer = (done) ->
	$.app.listen $.config.port, done

async.series [
	runSetups
	registerWorker
	startServer
], (err) ->
	return $.logger.log 'error', "error starting up codesubmit worker #{err.message}" if err
	$.logger.log 'info', "codeSubmit worker listen on port #{$.config.port}"
