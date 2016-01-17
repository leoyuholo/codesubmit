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

	$scope.listSubmissions = (asgId, email) ->
		list = _.partial submissionService.listByEmail, email if email
		list = _.partial submissionService.listByAsgId, asgId if asgId
		list = _.partial submissionService.listByAsgIdAndEmail, asgId, email if asgId && email

		list (err, data) ->
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

	if $scope.asgId || $scope.email then $scope.listSubmissions($scope.asgId, $scope.email) else $scope.showStats = true
