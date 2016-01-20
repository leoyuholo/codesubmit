app = angular.module 'codesubmit'

app.controller 'statisticsController', ($scope, $routeParams, $uibModal, submissionService, assignmentService, messageService) ->

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

			$scope.assignments = data.assignments

	$scope.listStats = () ->
		submissionService.listAssignmentStats (err, data) ->
			return messageService.error $scope.statsListMsg, err.message if err

			$scope.assignmentStats = data.stats
			$scope.students = data.students

	$scope.listStatsByAsgId = (asgId) ->
		submissionService.listSubmissionStatsByAsgId asgId, (err, data) ->
			return messageService.error $scope.statsListMsg, err.message if err

			$scope.submissionStats = _.sortByOrder data.stats, ['max', 'updateDt'], ['desc', 'asc']
			$scope.students = data.students
			$scope.assignment = data.assignment

	$scope.assignments = []
	$scope.assignmentListMsg = {}
	$scope.assignment = {}

	$scope.listAssignments()

	$scope.statsListMsg = {}
	$scope.submissionStats = []
	$scope.assignmentStats = []

	$scope.asgId = $routeParams.asgid if $routeParams.asgid

	if $scope.asgId then $scope.listStatsByAsgId $scope.asgId else $scope.listStats()
