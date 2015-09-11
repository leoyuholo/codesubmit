app = angular.module 'codeSubmit-admin'

app.controller 'SettingsController', ($scope, $location, userService) ->

	$scope.errorMessage = 'Sorry, under construction.'
