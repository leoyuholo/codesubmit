app = angular.module 'codesubmit'

app.controller 'assignmentsController', ($scope, assignmentService, messageService) ->

	$scope.now = new Date()
	$scope.ongoingAssignments = []
	$scope.archivedAssignments = []

	listAssignments = () ->
		assignmentService.listPublishedWithMyStats (err, data) ->
			return messageService.error err.message if err

			$scope.now = now = Date.now()
			_.each data.assignments, (asg) ->
				asg.completed = (asg.scoreStats?.max || 0) == asg.sandboxConfig?.testCaseNames?.length
				asg.hardoverdue = !asg.completed && asg.hardDueDt < now
				asg.overdue = !asg.completed && !asg.hardoverdue && asg.dueDt < now
				return

			[ongoingAssignments, archivedAssignments] = _.partition data.assignments, (a) -> a.hardDueDt >= now
			$scope.ongoingAssignments = _.sortByOrder ongoingAssignments, ['dueDt', 'name'], ['asc', 'asc']
			$scope.archivedAssignments = _.sortByOrder archivedAssignments, ['hardDueDt', 'name'], ['desc', 'asc']

	listAssignments()
