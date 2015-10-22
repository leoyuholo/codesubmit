app = angular.module 'codesubmit'

app.controller 'codesubmitHeaderController', ($scope, $rootScope, userService, redirectService) ->
	$scope.user = $rootScope.user

	$scope.logout = () ->
		userService.logout redirectService.redirectToHome

	return
