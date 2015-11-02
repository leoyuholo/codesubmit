app = angular.module 'codesubmit'

app.controller 'AssignmentController', ($scope, $routeParams, assignmentService, redirectService, submissionService, messageService) ->

	$scope.asgId = $routeParams.asgid
	$scope.assignmentDetailsMsg = {}
	$scope.assignmentSubmitMsg = {}
	$scope.assignment = {}
	$scope.localStorageKey = "assignment/#{$scope.asgId}"
	$scope.code = ''
	$scope.input = ''

	$scope.submit = () ->
		submit() if confirm 'Click cancel to improve your code.'

	$scope.run = () ->
		input = $scope.input
		output = if input == $scope.assignment.sampleInput then $scope.assignment.sampleOutput else ''

		messageService.success $scope.assignmentSubmitMsg, 'Running...'

		submissionService.run $scope.assignment.asgId, $scope.code, input, output, (err, data) ->
			return messageService.error $scope.assignmentSubmitMsg, err.message if err

			$scope.runResult = data.runResult

	submit = () ->
		submissionService.submit $scope.assignment.asgId, $scope.code, (err, data) ->
			return messageService.error $scope.assignmentSubmitMsg, err.message if err
			messageService.success $scope.assignmentSubmitMsg, 'Submitted.'

			redirectService.redirectTo 'submission', $scope.assignment.asgId, $scope.assignment.name, data.submission.subId, 'latest'

	findAssignment = (asgId) ->
		assignmentService.findByAsgId asgId, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err

			$scope.assignment = data.assignment

			$scope.code = localStorage.getItem($scope.localStorageKey) || $scope.assignment?.codeTemplate || '// Enter your code here.\n'

			$scope.input = $scope.assignment?.sampleInput

	findAssignment $scope.asgId
