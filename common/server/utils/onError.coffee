callerId = require 'caller-id'

module.exports = ($) ->

	onError = (done, err, args...) ->
		$.logger.log 'error', "onError: #{err.message} #{callerId.getDetailedString()} debugInfo: %j", err.debugInfo, {}
		argsArray = Array.prototype.slice.call args
		argsArray.unshift err
		done.apply null, argsArray

	return onError
