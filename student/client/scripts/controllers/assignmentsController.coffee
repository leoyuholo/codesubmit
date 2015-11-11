app = angular.module 'codesubmit'

app.controller 'AssignmentsController', ($scope, assignmentService, messageService) ->

	$scope.now = new Date()
	$scope.assignments = []

	sortAssignment = (assignments) ->
		_.sortByOrder assignments, ['dueDt', 'name'], ['asc', 'asc']

	listAssignments = () ->
		assignmentService.listPublishedWithMyStats (err, data) ->
			return messageService.error err.message if err

			now = Date.now()
			_.each data.assignments, (a) -> a.completed = a.scoreStats.max == a.sandboxConfig.testCaseNames.length
			$scope.assignments = _.flatten _.map (_.partition data.assignments, (a) -> !a.completed && a.hardDueDt >= now), sortAssignment

	listAssignments()
