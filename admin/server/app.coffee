mongoose = require 'mongoose'
async = require 'async'

$ = require './globals'

runSetups = (done) ->
	mongoose.connect "mongodb://#{$.config.mongodb.host}:#{$.config.mongodb.port}/#{$.config.mongodb.db}", done

startServer = (done) ->
	$.app.listen $.config.port, done

injectRootUser = (done) ->
	$.stores.adminStore.findByEmail 'leo@cse.cuhk.edu.hk', (err, admin) ->
		return console.log err if err
		return done null if admin
		$.stores.adminStore.create {email: 'leo@cse.cuhk.edu.hk', username: 'leo', password: 'leo'}, (err) ->
			return console.log err if err
			done null

async.series [
	runSetups
	startServer
	injectRootUser
], (err) ->
	console.log 'codeSubmit admin listen on port', $.config.port
