app = angular.module 'codesubmit'

app.controller 'AssignmentsController', ($scope, assignmentService, messageService) ->

	$scope.assignments = []

	listAssignments = () ->
		assignmentService.list (err, data) ->
			return messageService.error err.message if err

			$scope.assignments = _.sortByOrder data.assignments, 'dueDt', 'asc'

	listAssignments()
