app = angular.module 'codesubmit'

app.controller 'submissionsController', ($scope, $routeParams, submissionService, assignmentService, messageService) ->

	$scope.findAssignment = (asgId) ->
		assignmentService.findByAsgId asgId, (err, data) ->
			return messageService.error err.message if err

			$scope.assignment = data.assignment

	$scope.listSubmissions = (email, asgId) ->
		submissionService.listByAsgIdAndEmail asgId, email, (err, data) ->
			return messageService.error err.message if err

			$scope.submissions = data.submissions

	$scope.listStatistics = (email) ->
		submissionService.listSubmissionStatsByEmail email, (err, data) ->
			return messageService.error err.message if err

			$scope.submissionStats = data.stats

	$scope.email = $routeParams.email
	$scope.asgId = $routeParams.asgid if $routeParams.asgid

	$scope.assignment = {}
	$scope.submissions = []
	$scope.submissionStats = []

	if $scope.asgId
		$scope.findAssignment $scope.asgId
		$scope.listSubmissions $scope.email, $scope.asgId
	else
		$scope.listStatistics $scope.email
