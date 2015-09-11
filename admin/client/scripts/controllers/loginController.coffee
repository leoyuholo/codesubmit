app = angular.module 'codeSubmit-admin'

app.controller 'LoginController', ($scope, $location, userService) ->

	$scope.errorMessage = ''

	$scope.submitLogin = (email, password) ->
		userService.login email, password, (err, user) ->
			return $scope.errorMessage = err.message if err
			return $scope.errorMessage = 'Server response no users' if !user

			$location.path '/settings'
			$location.replace()
