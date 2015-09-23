$ = require '../globals'

module.exports = self = {}

self.list = (done) ->
	$.stores.assignmentStore.list (err, assignments) ->
		return $.utils.onError done, err if err
		done null, assignments.map $.models.Assignment.envelop

self.findByAsgId = (asgId, done) ->
	$.stores.assignmentStore.findByAsgId asgId, (err, assignment) ->
		return $.utils.onError done, err if err
		return $.utils.onError done, new Error("Assignment with asgId: [#{asgId}] not found.") if !assignment

		done null, $.models.Assignment.envelop assignment

self.create = (assignment, done) ->
	assignment.asgId = $.utils.rng.generateId()
	assignment.sandboxConfigFileStorageKey = "assignment/sanndboxConfigFiles/#{assignment.asgId}"

	$.stores.assignmentStore.create assignment, (err) ->
		return $.utils.onError done, err if err
		done null, $.models.Assignment.envelop assignment

self.update = (assignment, done) ->
	$.stores.assignmentStore.update assignment, (err) ->
		return $.utils.onError done, err if err
		done null
