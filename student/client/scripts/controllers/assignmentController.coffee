app = angular.module 'codesubmit'

app.controller 'assignmentController', ($scope, $routeParams, assignmentService, redirectService, submissionService, messageService) ->

	$scope.asgId = $routeParams.asgid
	$scope.assignmentDetailsMsg = {}
	$scope.assignmentSubmitMsg = {}
	$scope.assignmentRunMsg = {}
	$scope.assignment = {}
	$scope.runResult = {}

	$scope.code = ''
	$scope.codeLocalStorageKey = "assignment/#{$scope.asgId}"
	$scope.codeAceOptions =
		maxLines: Infinity

	$scope.input = ''
	$scope.inputLocalStorageKey = "input/#{$scope.asgId}"
	$scope.inputAceOptions =
		minLines: 6
		showInvisibles: true
		theme: 'twilight'
		showGutter: false

	$scope.submit = () ->
		submit() if confirm 'Click ok to submit your code.'

	$scope.run = () ->
		input = $scope.input
		output = if input == $scope.assignment.sampleInput then $scope.assignment.sampleOutput else ''

		$scope.runResult = {}
		messageService.success $scope.assignmentRunMsg, 'Running...'

		submissionService.run $scope.assignment.asgId, $scope.code, input, output, (err, data) ->
			return messageService.error $scope.assignmentRunMsg, err.message if err

			$scope.runResult = data.runResult

			messageService.clear $scope.assignmentRunMsg

	submit = () ->
		submissionService.submit $scope.assignment.asgId, $scope.code, (err, data) ->
			return messageService.error $scope.assignmentSubmitMsg, err.message if err
			messageService.success $scope.assignmentSubmitMsg, 'Submitted.'

			redirectService.redirectTo 'submission', $scope.assignment.asgId, $scope.assignment.name, data.submission.subId, 'latest'

	findAssignment = (asgId) ->
		assignmentService.findByAsgId asgId, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err

			$scope.assignment = data.assignment

			$scope.code = localStorage.getItem($scope.codeLocalStorageKey) || $scope.assignment?.codeTemplate || '// Enter your code here.\n'

			$scope.input = localStorage.getItem($scope.inputLocalStorageKey)
			if $scope.input == undefined || $scope.input == null
				$scope.input = $scope.assignment?.sampleInput

	findAssignment $scope.asgId
