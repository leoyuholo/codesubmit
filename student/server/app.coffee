async = require 'async'

$ = require './globals'

runSetups = (done) ->
	process.nextTick () ->
		async.eachSeries $.setups, ( (setup, done) ->
			setup.run done
		), done

startServer = (done) ->
	$.app.listen $.config.port, done

async.series [
	runSetups
	startServer
], (err) ->
	return console.log 'error starting up codeSubmit student', err if err
	console.log 'codeSubmit student listen on port', $.config.port