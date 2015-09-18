app = angular.module 'codesubmit-admin'

app.controller 'SubmissionsController', ($scope, $location, userService) ->

	$scope.errorMessage = 'Sorry, under construction.'
