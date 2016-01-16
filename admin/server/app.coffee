async = require 'async'

$ = require './globals'

injectRootUser = (done) ->
	$.stores.adminStore.findByEmail $.config.rootUser.email, (err, admin) ->
		return $.utils.onError done, err if err
		return done null if admin

		$.services.adminService.create {email: $.config.rootUser.email, username: 'root', remarks: 'root'}, (err) ->
			return $.utils.onError done, err if err

			done null

async.series [
	$.run.setup
	$.run.server
	injectRootUser
], (err) ->
	return $.logger.log 'error', "error starting up codesubmit admin #{err.message}" if err
	$.logger.log 'info', "[#{$.app.get('env')}]codeSubmit admin listen on port #{$.config.port}"
