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
	return console.log 'error starting up codeSubmit worker', err if err
	console.log 'codeSubmit worker listen on port', $.config.port
