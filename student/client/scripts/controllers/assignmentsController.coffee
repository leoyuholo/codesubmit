app = angular.module 'codesubmit'

app.controller 'AssignmentsController', ($scope, assignmentService, messageService) ->

	$scope.now = new Date()
	$scope.assignments = []

	listAssignments = () ->
		assignmentService.listWithMyStats (err, data) ->
			return messageService.error err.message if err

			$scope.assignments = _.sortByOrder data.assignments, 'dueDt', 'asc'

	listAssignments()
