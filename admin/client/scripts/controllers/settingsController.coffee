app = angular.module 'codesubmit-admin'

app.controller 'SettingsController', ($scope, $location, userService) ->

	$scope.errorMessage = 'Sorry, under construction.'
