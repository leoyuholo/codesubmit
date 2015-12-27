app = angular.module 'codesubmit'

app.controller 'exportSubmissionsController', ($scope, submissionService, assignmentService, studentService, messageService) ->

	$scope.exportDataMsg = {}

	$scope.exportDataAceOptions =
		showGutter: false
		readOnly: true

	$scope.exportData = ''

	constructStats = (stats, assignments, students) ->
		assignmentByAsgId = _.indexBy assignments, 'asgId'
		studentByEmail = _.indexBy students, 'email'

		_.map _.groupBy(stats, 'tags.email'), (stats, email) ->
			record = _.reduce stats, ((result, stat) ->
				assignment = assignmentByAsgId[stat.tags.asgId]
				result[assignment.name] = stat.max
				return result
			), {}

			student = studentByEmail[email]

			record.email = student.email
			record.username = student.username
			record.remarks = student.remarks

			return record

	listScoreStats = () ->
		async.parallel [
			submissionService.listScoreStats
			assignmentService.list
			studentService.list
		], (err, [statsData, assignmentsData, studentsData]) ->
			return messageService.error $scope.exportDataMsg, err.message if err

			$scope.exportData = Papa.unparse
				fields: ['email', 'username', 'remarks'].concat _.pluck(assignmentsData.assignments, 'name').sort()
				data: constructStats statsData.stats, assignmentsData.assignments, studentsData.students

	listScoreStats()
