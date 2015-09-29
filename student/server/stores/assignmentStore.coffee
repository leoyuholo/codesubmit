$ = require '../globals'

Assignment = $.models.Assignment

module.exports = self = {}

self.list = (done) ->
	Assignment.find {}, done
