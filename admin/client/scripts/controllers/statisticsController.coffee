app = angular.module 'codesubmit'

app.controller 'statisticsController', ($scope, $routeParams, $uibModal, submissionService, assignmentService, studentService, messageService) ->

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

	$scope.listStats = () ->
		submissionService.listAssignmentStats (err, data) ->
			return messageService.error $scope.statsListMsg, err.message if err

			now = Date.now()
			$scope.assignmentStats = _.flatten _.map (_.partition data.stats, (s) -> s.assignment.dueDt >= now), (ss) -> _.sortByOrder ss, ['assignment.dueDt', 'assignment.name'], ['asc', 'asc']
			$scope.assignments = _.flatten _.map (_.partition data.assignments, (a) -> a.dueDt >= now), assignmentService.sort

		studentService.list (err, data) ->
			return messageService.error $scope.statsListMsg, err.message if err

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

	$scope.statsListMsg = {}
	$scope.submissionStats = []
	$scope.assignmentStats = []

	$scope.asgId = $routeParams.asgid if $routeParams.asgid

	if $scope.asgId
		$scope.listAssignments()
		$scope.listStatsByAsgId $scope.asgId
	else
		$scope.listStats()
