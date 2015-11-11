app = angular.module 'codesubmit'

app.controller 'SubmissionsController', ($scope, $routeParams, submissionService, assignmentService, messageService) ->

	$scope.listAssignments = () ->
		assignmentService.list (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			now = Date.now()
			$scope.assignments = _.flatten _.map (_.partition data.assignments, (a) -> a.dueDt >= now), assignmentService.sortAssignment

	$scope.listSubmissions = (asgId) ->
		submissionService.list asgId, (err, data) ->
			return messageService.error $scope.submissionListMsg, err.message if err

			$scope.submissions = data.submissions

	$scope.assignments = []
	$scope.assignmentListMsg = {}
	$scope.submissions = []
	$scope.submissionListMsg = {}

	$scope.listAssignments()
	$scope.asgId = $routeParams.asgid if $routeParams.asgid
	$scope.listSubmissions $scope.asgId if $scope.asgId
