app = angular.module 'codesubmit'

app.controller 'SubmissionController', ($scope, $routeParams, submissionService, messageService) ->

	$scope.asgId = $routeParams.asgid
	$scope.asgName = $routeParams.asgname
	$scope.subId = $routeParams.subid
	$scope.subName = if _.isNaN +$routeParams.subname then $routeParams.subname else 'Attempt # ' + $routeParams.subname
	$scope.submission = {}
	$scope.code = ''

	findSubmission = (subId) ->
		submissionService.findMineBySubId subId, (err, data) ->
			return messageService.error err.message if err

			$scope.submission = data.submission

			$scope.code = $scope.submission.code

	findSubmission $scope.subId
