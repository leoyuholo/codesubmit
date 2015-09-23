app = angular.module 'codesubmit-admin'

app.controller 'SubmissionsController', ($scope, $routeParams, submissionService, assignmentService, messageService) ->

	$scope.assignments = []
	$scope.assignmentListMsg = {}

	$scope.listAssignments = () ->
		assignmentService.listAssignments (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			$scope.assignments = data.assignments

	$scope.submissions = []
	$scope.submissionListMsg = {}

	$scope.listSubmisstion = (asgId) ->
		submissionService.list asgId, (err, data) ->
			return messageService.error $scope.submissionListMsg, err.message if err

			$scope.submissions = data.submissions

	$scope.asgId = $routeParams.id if $routeParams.id

	$scope.listSubmisstion $scope.asgId if $scope.asgId

	$scope.listAssignments()
