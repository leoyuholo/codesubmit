app = angular.module 'codesubmit'

app.controller 'codesubmitHeaderController', ($scope, $rootScope, userService, redirectService) ->

	$scope.logout = () ->
		userService.logout redirectService.redirectToHome

	$scope.user = $rootScope.user
