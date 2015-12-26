app = angular.module 'codesubmit'

app.controller 'importStudentsController', ($scope, studentService) ->

	$scope.importDataLocalStorageKey = 'importStudents'
	$scope.importDataAceOptions =
		showGutter: false

	$scope.importData = localStorage.getItem($scope.importDataLocalStorageKey)

	$scope.importStudents = (importData) ->
		console.log csv
