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
	return $.logger.log 'error', "error starting up codesubmit student #{err.message}" if err
	$.logger.log 'info', "codeSubmit student listen on port #{$.config.port}"
