app = angular.module 'codesubmit'

app.service 'assignmentService', (urlService) ->
	self = {}

	self.sort = (assignments) ->
		_.sortByOrder assignments, ['dueDt', 'name'], ['asc', 'asc']

	self.list = (done) ->
		urlService.get urlService.assignment.list(), done

	self.listPublishedWithMyStats = (done) ->
		async.parallel [
			_.partial urlService.get, urlService.assignment.listPublished()
			_.partial urlService.get, urlService.submission.listMyScoreStats()
		], (err, [assignmentsData, statsData]) ->
			return done err if err

			[assignments, stats] = [assignmentsData.assignments, statsData.stats]

			stats = _.indexBy stats, (stat) -> stat.tags.asgId

			_.each assignments, (assignment) ->
				stat = stats[assignment.asgId]
				if stat
					assignment.scoreStats = {}
					assignment.scoreStats.max = stat.max
					assignment.scoreStats.count = stat.count

			done null, {success: true, assignments: assignments}

	self.findByAsgId = (asgId, done) ->
		urlService.get urlService.assignment.findByAsgId(asgId), done

	self.create = (assignment, done) ->
		payload =
			assignment: assignment

		urlService.post urlService.assignment.create(), payload, done

	self.update = (assignment, done) ->
		payload =
			assignment: assignment

		urlService.post urlService.assignment.update(), payload, done

	self.updateTestCaseNames = (asgId, testCaseNames, done) ->
		payload =
			assignment:
				asgId: asgId
				'sandboxConfig.testCaseNames': testCaseNames

		urlService.post urlService.assignment.update(), payload, done

	self.remove = (assignment, done) ->
		payload=
			assignment: assignment

		urlService.post urlService.assignment.remove(), payload, done

	return self
