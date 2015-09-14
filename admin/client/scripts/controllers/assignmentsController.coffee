app = angular.module 'codesubmit-admin'

app.controller 'AssignmentsController', ($scope, $location, userService) ->

	$scope.errorMessage = 'Sorry, under construction.'
