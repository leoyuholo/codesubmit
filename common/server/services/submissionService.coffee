_ = require 'lodash'
async = require 'async'

module.exports = ($) ->
	self = {}

	self.updateScoreStats = (subId, done) ->
		self.findBySubId subId, (err, submission) ->
			return $.utils.onError done, err if err

			$.services.submissionService.list {asgId: submission.asgId, email: submission.email}, (err, submissions) ->
				return $.utils.onError done, err if err

				stats =
					tags:
						key: 'submission.score'
						email: submission.email
						asgId: submission.asgId
					max: _.max _.pluck(submissions, 'score').concat(0)
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
		condition = {asgId: condition} if _.isString condition
		$.stores.submissionStore.list condition, (err, submissions) ->
			return $.utils.onError done, err if err

			done null, submissions.map $.models.Submission.envelop

	self.findBySubId = (condition, done) ->
		condition = {subId: condition} if _.isString condition
		$.stores.submissionStore.findBySubId condition, (err, submission) ->
			return $.utils.onError done, err if err
			return $.utils.onError done, new Error("Submission with subId: [#{condition.subId}] not found.") if !submission

			done null, $.models.Submission.envelop submission

	self.run = (student, asgId, code, input, output, done) ->
		submission =
			subId: $.utils.rng.generateId()
			asgId: asgId
			email: student.email
			submitDt: new Date()
			code: code
			type: if output then 'run' else 'eval'
			input: input
			output: output

		$.stores.mqStore.rpc submission, (err, runResult) ->
			return $.utils.onError done, err if err
			done null, runResult

	self.submit = (student, asgId, code, done) ->
		async.parallel [
			_.partial $.services.assignmentService.findByAsgId, asgId
			_.partial $.services.statsService.findByTags, {key: 'submission.score', asgId: asgId, email: student.email}
		], (err, [assignment, stats]) ->
			return $.utils.onError done, err if err
			return done new Error('Submission Limit Exceeded.') if stats.count >= assignment.submissionLimit

			submission =
				subId: $.utils.rng.generateId()
				asgId: asgId
				email: student.email
				submitDt: new Date()
				code: code
				status: 'pending'
				results: assignment.sandboxConfig.testCaseNames.map (n) -> {testCaseName: n, status: 'pending'}

			$.stores.submissionStore.create submission, (err, submission) ->
				return $.utils.onError done, err if err

				$.stores.mqStore.pushTask submission

				# $.stores.mqStore.subscribe submission.subId, (runResult) ->
				# 	console.log 'subscribe received', runResult

				done null, submission

	return self
