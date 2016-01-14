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

			[assignments, statses] = [assignmentsData.assignments, statsData.stats]

			statses = _.indexBy statses, (stats) -> stats.tags.asgId

			_.each assignments, (assignment) ->
				stats = statses[assignment.asgId]
				if stats
					assignment.scoreStats = {}
					assignment.scoreStats.max = stats.max
					assignment.scoreStats.count = stats.count

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

	self.remove = (assignment, done) ->
		payload=
			assignment: assignment

		urlService.post urlService.assignment.remove(), payload, done

	return self
