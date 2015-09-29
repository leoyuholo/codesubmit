app = angular.module 'codesubmit-student'

app.directive 'codesubmitHeader', () ->
	return {
		restrict: 'A'
		templateUrl: 'views/codesubmitHeader'
		controller: 'codesubmitHeaderController'
	}
