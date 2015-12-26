app = angular.module 'codesubmit'

app.controller 'submissionsController', ($scope, $routeParams, submissionService, messageService) ->

	$scope.asgId = $routeParams.asgid
	$scope.asgName = $routeParams.asgname
	$scope.submissions = []

	listSubmissions = (asgId) ->
		submissionService.listMine asgId, (err, data) ->
			return messageService.error err.message if err

			$scope.submissions = _.sortByOrder data.submissions, 'submitDt', 'desc'

	listSubmissions $scope.asgId
