callerId = require 'caller-id'

$ = require '../globals'

onError = (done, err, args...) ->
	console.log 'error', "onError: #{err.message} #{callerId.getDetailedString()} debugInfo: %j", err.debugInfo, {}
	argsArray = Array.prototype.slice.call args
	argsArray.unshift err
	done.apply null, argsArray

module.exports = onError
