app = angular.module 'codesubmit'

app.controller 'exportSubmissionsController', ($scope, submissionService, messageService) ->

	$scope.exportDataMsg = {}

	$scope.exportDataAceOptions =
		showGutter: false
		readOnly: true

	$scope.exportData = ''

	listScoreStats = () ->
		submissionService.listSubmissionStats (err, data) ->
			return messageService.error $scope.exportDataMsg, err.message if err

			records = _.map data.students, (student) ->
				record =
					email: student.email
					username: student.username
					remarks: student.remarks

				_.each student.stats, (stat) ->
					record[stat.assignment.name] = stat.max

				return record

			$scope.exportData = Papa.unparse
				fields: ['email', 'username', 'remarks'].concat _.pluck(data.assignments, 'name').sort()
				data: records

	listScoreStats()
