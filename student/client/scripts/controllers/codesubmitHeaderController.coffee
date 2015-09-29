app = angular.module 'codesubmit-student'

app.controller 'codesubmitHeaderController', ($scope, $rootScope, userService, redirectService) ->
	$scope.user = $rootScope.user

	$scope.logout = () ->
		userService.logout redirectService.redirectToHome

	return
