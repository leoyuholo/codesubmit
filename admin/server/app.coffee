mongoose = require 'mongoose'
async = require 'async'

$ = require './globals'

runSetups = (done) ->
	mongoose.connect "mongodb://#{$.config.mongodb.host}:#{$.config.mongodb.port}/#{$.config.mongodb.db}", done

startServer = (done) ->
	$.app.listen $.config.port, done

async.series [
	runSetups
	startServer
], (err) ->
	$.stores.userStore.create {email: 'leo@cse.cuhk.edu.hk', username: 'leo', password: 'leo'}, (err) ->
		console.log(err) if err
		console.log 'codeSubmit admin listen on port', $.config.port
