app = angular.module 'codesubmit-admin'

app.controller 'codesubmitHeaderController', ($scope, $rootScope) ->

	$scope.user = $rootScope.user

	$scope.logout = $rootScope.logout

	return
