app = angular.module 'codesubmit'

app.service 'submissionService', (urlService) ->
	self = {}

	self.listAssignmentStats = (done) ->
		async.parallel [
			_.partial urlService.get, urlService.assignment.list()
			_.partial urlService.get, urlService.assignment.listScoreStats()
		], (err, [assignmentsData, statsData]) ->
			return done err if err

			[assignments, stats] = [assignmentsData.assignments, statsData.stats]

			stats = _.indexBy stats, (stat) -> stat.tags.asgId

			stats = _.map assignments, (assignment) ->
				_.set (stats[assignment.asgId] || {}), 'assignment', assignment

			done null, {success: true, stats: stats, assignments: assignments}

	# self.listSubmissionStats = (done) ->
	# 	async.parallel [
	# 		_.partial urlService.get, urlService.assignment.list()
	# 		_.partial urlService.get, urlService.student.list()
	# 		_.partial urlService.get, urlService.submission.listScoreStats()
	# 	], (err, [assignmentsData, studentsData, statsData]) ->
	# 		return done err if err

	# 		[assignments, students, stats] = [assignmentsData.assignments, studentsData.students, statsData.stats]

	# 		statsByEmail = _.groupBy stats, (stat) -> stat.tags.email
	# 		assignmentsByAsgId = _.indexBy assignments, (asg) -> asg.asgId

	# 		_.each students, (student) ->
	# 			student.stats = statsByEmail[student.email]
	# 			_.each student.stats, (stat) ->
	# 				stat.assignment = assignmentsByAsgId[stat.tags.asgId]

	# 		done null, {success: true, stats: stats, students: students, assignments: assignments}

	self.listSubmissionStats = (done) ->
		async.parallel [
			_.partial urlService.get, urlService.assignment.list()
			_.partial urlService.get, urlService.student.list()
		], (err, [assignmentsData, studentsData]) ->
			return done err if err

			[assignments, students] = [assignmentsData.assignments, studentsData.students]

			async.map assignments, ( (assignment, done) ->
				urlService.get urlService.submission.listByAsgId(assignment.asgId), (err, submissionsData) ->
					return done err if err
					submissionByEmail = _.groupBy submissionsData.submissions, (s) -> s.email
					stats = _.map submissionByEmail, (submissions, email) ->
						max = _.max _.map submissions, (s) ->
							return 0 if s.submitDt > assignment.hardDueDt
							return s.score * (100 - assignment.penalty) / 100 if s.submitDt > assignment.dueDt
							return s.score
						return {
							tags:
								email: email
								asgId: assignment.asgId
							max: max || 0
							count: submissions.length
						}
					done null, stats
			), (err, stats) ->
				return done err if err

				stats = _.flatten stats

				statsByEmail = _.groupBy stats, (stat) -> stat.tags.email
				assignmentsByAsgId = _.indexBy assignments, (asg) -> asg.asgId

				_.each students, (student) ->
					student.stats = statsByEmail[student.email]
					_.each student.stats, (stat) ->
						stat.assignment = assignmentsByAsgId[stat.tags.asgId]

				done null, {success: true, stats: stats, students: students, assignments: assignments}

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
