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
	console.log 'codeSubmit worker listen on port', $.config.port
