_ = require 'lodash'
async = require 'async'

module.exports = ($) ->
	self = {}

	self.updateScoreStats = (asgId, done) ->
		$.services.statService.findByTags {key: 'submission.score', asgId: asgId}, (err, stats) ->
			return $.utils.onError done, err if err

			stat =
				tags:
					key: 'assignment.score'
					asgId: asgId
				max: _.max _.pluck(stats, 'max').concat(0)
				count: stats.length
				updateDt: new Date()

			$.services.statService.update stat, (err) ->
				return $.utils.onError done, err if err

				done null

	self.listScoreStats = (done) ->
		$.services.statService.findByTags {key: 'assignment.score'}, (err, stats) ->
			return $.utils.onError done, err if err

			done null, _.map stats, $.models.Stat.envelop

	self.list = (done) ->
		$.stores.assignmentStore.list (err, assignments) ->
			return $.utils.onError done, err if err
			done null, assignments.map $.models.Assignment.envelop

	self.listPublished = (done) ->
		self.list (err, assignments) ->
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

	self.remove = (assignment, done) ->
		self.findByAsgId assignment.asgId, (err, assignment) ->
			return $.utils.onError done, err if err

			async.series [
				_.partial $.stores.assignmentStore.removeByAsgId, assignment.asgId
				_.partial $.stores.storageStore.remove, assignment.testCaseFileStorageKey
				_.partial $.stores.submissionStore.removeByAsgId, assignment.asgId
			], done

	return self
