_ = require 'lodash'

module.exports = ($) ->
	self = {}

	self.updateScoreStats = (asgId, email, done) ->
		$.services.submissionService.list {asgId: asgId, email: email}, (err, submissions) ->
			return $.utils.onError done, err if err

			stats =
				tags:
					key: 'submission.score'
					email: email
					asgId: asgId
				max: _.max _.pluck submissions, 'score'
				count: submissions.length
				updateDt: new Date()

			$.services.statsService.update stats, (err) ->
				return $.utils.onError done, err if err

				done null

	self.findScoreStatsByEmail = (email, done) ->
		$.services.statsService.findByTags {key: 'submission.score', email: email}, (err, statses) ->
			return $.utils.onError done, err if err

			done null, _.map statses, $.models.Stats.envelop

	self.list = (condition, done) ->
		$.stores.submissionStore.list condition, (err, submissions) ->
			return $.utils.onError done, err if err

			done null, submissions.map $.models.Submission.envelop

	self.findBySubId = (condition, done) ->
		$.stores.submissionStore.findBySubId condition, (err, submission) ->
			return $.utils.onError done, err if err
			return $.utils.onError done, new Error("Submission with subId: [#{condition.subId}] not found.") if !submission

			done null, $.models.Submission.envelop submission

	self.submit = (student, asgId, code, done) ->
		submission =
			subId: $.utils.rng.generateId()
			asgId: asgId
			email: student.email
			submitDt: new Date()
			code: code

		$.stores.submissionStore.create submission, (err, submission) ->
			return $.utils.onError done, err if err

			$.stores.mqStore.push submission, (err) ->
				return $.utils.onError done, err if err

				done null, $.models.Submission.envelop submission

	return self
