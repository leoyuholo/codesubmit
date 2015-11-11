app = angular.module 'codesubmit'

app.controller 'SubmissionController', ($scope, $routeParams, assignmentService, submissionService, messageService) ->

	$scope.asgId = $routeParams.asgid
	$scope.asgName = $routeParams.asgname
	$scope.subId = $routeParams.subid
	$scope.subName = if _.isNaN +$routeParams.subname then $routeParams.subname else 'Attempt # ' + $routeParams.subname
	$scope.assignment = {}
	$scope.submission = {}
	$scope.code = ''

	findAssignment = (asgId) ->
		assignmentService.findByAsgId asgId, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err

			$scope.assignment = data.assignment

	reloadSubmission = () ->
		if $scope.submission.status == 'pending'
			submissionService.findMineBySubId $scope.submission.subId, (err, data) ->
				$scope.submission.results = data.submission.results if data.submission?.results
				setTimeout reloadSubmission, 1500

	findSubmission = (subId) ->
		submissionService.findMineBySubId subId, (err, data) ->
			return messageService.error err.message if err

			$scope.submission = data.submission

			$scope.code = $scope.submission.code

	findAssignment $scope.asgId
	findSubmission $scope.subId
