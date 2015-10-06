async = require 'async'

$ = require './globals'

runSetups = (done) ->
	process.nextTick () ->
		async.eachSeries $.setups, ( (setup, done) ->
			setup.run done
		), done

registerWorker = (done) ->
	$.stores.mqStore.worker $.services.workerService.work
	done null

startServer = (done) ->
	$.app.listen $.config.port, done

async.series [
	runSetups
	registerWorker
	startServer
], (err) ->
	console.log 'codeSubmit worker listen on port', $.config.port
