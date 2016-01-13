app = angular.module 'codesubmit'

app.controller 'submissionsController', ($scope, $routeParams, $uibModal, submissionService, assignmentService, messageService) ->

	$scope.openExport = () ->
		options =
			templateUrl: 'views/exportSubmissions'
			controller: 'exportSubmissionsController'
			animation: false
			size: 'lg'

		$uibModal.open options

	$scope.listAssignments = () ->
		assignmentService.list (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			now = Date.now()
			$scope.assignments = _.flatten _.map (_.partition data.assignments, (a) -> a.dueDt >= now), assignmentService.sort
			$scope.assignment = _.find $scope.assignments, {asgId: $scope.asgId} if $scope.asgId

	$scope.listSubmissions = (asgId) ->
		submissionService.list asgId, (err, data) ->
			return messageService.error $scope.submissionListMsg, err.message if err

			$scope.submissions = data.submissions

	$scope.listSubmissionsByEmail = (asgId, email) ->
		submissionService.listByEmail asgId, email, (err, data) ->
			return messageService.error $scope.submissionListMsg, err.message if err

			$scope.submissions = data.submissions

	$scope.assignments = []
	$scope.assignmentListMsg = {}
	$scope.assignment = {}
	$scope.displayedSubmissions = []
	$scope.submissions = []
	$scope.submissionListMsg = {}

	$scope.listAssignments()
	$scope.asgId = $routeParams.asgid if $routeParams.asgid
	$scope.email = $routeParams.email if $routeParams.email
	if $scope.asgId
		if $scope.email
			$scope.listSubmissionsByEmail $scope.asgId, $scope.email
		else
			$scope.listSubmissions $scope.asgId
