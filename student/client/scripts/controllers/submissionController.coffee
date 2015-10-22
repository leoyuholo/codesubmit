app = angular.module 'codesubmit'

app.controller 'SubmissionController', ($scope, $routeParams, submissionService, messageService) ->

	editor = {}

	$scope.asgId = $routeParams.asgid
	$scope.asgName = $routeParams.asgname
	$scope.subId = $routeParams.subid
	$scope.subName = if _.isNaN +$routeParams.subname then $routeParams.subname else 'Attempt # ' + $routeParams.subname
	$scope.submission = {}

	findSubmission = (subId) ->
		submissionService.findMineBySubId subId, (err, data) ->
			return messageService.error err.message if err

			$scope.submission = data.submission

			editor.getSession().setValue $scope.submission.code

	initEditor = () ->
		editor = ace.edit 'editor'

		editor.$blockScrolling = Infinity

	initEditor()
	findSubmission $scope.subId
