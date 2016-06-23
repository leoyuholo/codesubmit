app = angular.module 'codesubmit'

app.controller 'submissionController', ($scope, $routeParams, assignmentService, submissionService, messageService) ->

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
		if $scope.submission.status == 'pending' || $scope.submission.status == 'running'
			submissionService.findMineBySubId $scope.submission.subId, (err, data) ->
				if data.submission?.results
					$scope.submission.status = data.submission.status
					$scope.submission.results = data.submission.results
					$scope.submission.score = data.submission.score
					setTimeout reloadSubmission, 1000

	findSubmission = (subId) ->
		submissionService.findMineBySubId subId, (err, data) ->
			return messageService.error err.message if err

			$scope.submission = data.submission

			$scope.code = $scope.submission.code

			reloadSubmission()

	findAssignment $scope.asgId
	findSubmission $scope.subId
