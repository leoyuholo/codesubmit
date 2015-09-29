app = angular.module 'codesubmit-student'

app.controller 'SubmissionsController', ($scope, $routeParams) ->

	$scope.asgId = $routeParams.id if $routeParams.id
