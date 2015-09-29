$ = require '../globals'

module.exports = self = {}

self.list = (done) ->
	$.stores.assignmentStore.list (err, assignments) ->
		return $.utils.onError done, err if err
		done null, assignments.map $.models.Assignment.envelop
