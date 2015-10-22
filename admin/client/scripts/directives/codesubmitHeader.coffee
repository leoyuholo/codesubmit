app = angular.module 'codesubmit'

app.directive 'codesubmitHeader', () ->
	return {
		restrict: 'A'
		templateUrl: 'views/codesubmitHeader'
		controller: 'codesubmitHeaderController'
	}
