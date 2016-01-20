app = angular.module 'codesubmit'

app.service 'submissionService', (urlService) ->
	self = {}

	self.listAssignmentStats = (done) ->
		async.parallel [
			_.partial urlService.get, urlService.assignment.list()
			_.partial urlService.get, urlService.student.list()
			_.partial urlService.get, urlService.submission.listScoreStats()
		], (err, [assignmentsData, studentsData, statsData]) ->
			return done err if err

			[assignments, students, stats] = [assignmentsData.assignments, studentsData.students, statsData.stats]

			stats = _.groupBy stats, (stat) -> stat.tags.asgId

			stats = _.map assignments, (assignment) ->
				assignmentStats = stats[assignment.asgId]
				assignmentStats = [] if !assignmentStats
				stat =
					count: assignmentStats.length
					max: _.max(assignmentStats, 'max').max
					distribution: _.countBy assignmentStats, 'max'

				stat.assignment = assignment
				return stat

			done null, {success: true, stats: stats, assignments: assignments, students: students}

	self.listSubmissionStatsByAsgId = (asgId, done) ->
		async.parallel [
			_.partial urlService.get, urlService.assignment.findByAsgId(asgId)
			_.partial urlService.get, urlService.student.list()
			_.partial urlService.get, urlService.submission.listScoreStatsByAsgId(asgId)
		], (err, [assignmentData, studentsData, statsData]) ->
			return done err if err

			[assignment, students, stats] = [assignmentData.assignment, studentsData.students, statsData.stats]

			stats = _.indexBy stats, (stat) -> stat.tags.email

			stats = _.map students, (student) ->
				stat = stats[student.email]
				stat = {max: 0, count: 0, updateDt: null} if !stat
				stat.student = student
				stat.assignment = assignment
				return stat

			done null, {success: true, stats: stats, assignment: assignment, students: students}

	self.listSubmissionStatsByEmail = (email, done) ->
		async.parallel [
			_.partial urlService.get, urlService.assignment.list()
			_.partial urlService.get, urlService.submission.listScoreStatsByEmail(email)
		], (err, [assignmentData, statsData]) ->
			return done err if err

			[assignments, stats] = [assignmentData.assignments, statsData.stats]

			stats = _.indexBy stats, (stat) -> stat.tags.asgId

			stats = _.map assignments, (asg) ->
				stat = stats[asg.asgId]
				stat = {max: 0, count: 0, updateDt: null} if !stat
				stat.assignment = asg
				return stat

			done null, {success: true, stats: stats, assignments: assignments}

	self.findMyScoreStatsByAsgId = (asgId, done) ->
		urlService.get urlService.submission.findMyScoreStatsByAsgId(asgId), done

	self.listScoreStats = (done) ->
		urlService.get urlService.submission.listScoreStats(), done

	self.listByAsgId = (asgId, done) ->
		urlService.get urlService.submission.listByAsgId(asgId), done

	self.listByEmail = (email, done) ->
		urlService.get urlService.submission.listByEmail(email), done

	self.listByAsgIdAndEmail = (asgId, email, done) ->
		urlService.get urlService.submission.listByAsgIdAndEmail(asgId, email), done

	self.listMineByAsgId = (asgId, done) ->
		urlService.get urlService.submission.listMineByAsgId(asgId), done

	self.findBySubId = (subId, done) ->
		urlService.get urlService.submission.findBySubId(subId), done

	self.findMineBySubId = (subId, done) ->
		urlService.get urlService.submission.findMineBySubId(subId), done

	self.run = (asgId, code, input, output, done) ->
		payload =
			code: code
			input: input
			output: output

		urlService.post urlService.submission.run(asgId), payload, done

	self.submit = (asgId, code, done) ->
		payload =
			code: code

		urlService.post urlService.submission.submit(asgId), payload, done

	return self
