app = angular.module 'codesubmit'

app.controller 'exportAssignmentController', ($scope, assignment) ->

	$scope.assignment = assignment

	$scope.exportAssignmentMsg = {}

	$scope.exportAssignmentAceOptions =
		showGutter: false
		readOnly: true

	$scope.exportAssignment = JSON.stringify _.omit(assignment, ['asgId', 'testCaseFileStorageKey']), null, '  '
