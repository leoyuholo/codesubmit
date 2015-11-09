_ = require 'lodash'

module.exports = ($) ->
	self = {}

	self.list = (done) ->
		$.stores.assignmentStore.list (err, assignments) ->
			return $.utils.onError done, err if err
			done null, assignments.map $.models.Assignment.envelop

	self.listWithMyStats = (email, done) ->
		self.list (err, assignments) ->
			return $.utils.onError done, err if err

			$.services.submissionService.findScoreStatsByEmail email, (err, statses) ->
				return $.utils.onError done, err if err

				statses = _.indexBy statses, (stats) -> stats.tags.asgId

				_.each assignments, (assignment) ->
					stats = statses[assignment.asgId]
					if stats
						assignment.scoreStats = {}
						assignment.scoreStats.max = stats.max
						assignment.scoreStats.count = stats.count

				done null, assignments

	self.listPublishedWithMyStats = (email, done) ->
		self.listWithMyStats email, (err, assignments) ->
			return $.utils.onError done, err if err
			now = Date.now()
			done null, _.filter assignments, (asg) -> asg.startDt < now

	self.findByAsgId = (asgId, done) ->
		$.stores.assignmentStore.findByAsgId asgId, (err, assignment) ->
			return $.utils.onError done, err if err
			return $.utils.onError done, new Error("Assignment with asgId: [#{asgId}] not found.") if !assignment

			done null, $.models.Assignment.envelop assignment

	self.create = (assignment, done) ->
		assignment.asgId = $.utils.rng.generateId()
		assignment.testCaseFileStorageKey = $.services.namespaceService.makeStorageKey 'testCaseFiles', assignment.asgId

		$.stores.assignmentStore.create assignment, (err) ->
			return $.utils.onError done, err if err
			done null, $.models.Assignment.envelop assignment

	self.update = (assignment, done) ->
		$.stores.assignmentStore.update assignment, (err) ->
			return $.utils.onError done, err if err
			done null

	return self
