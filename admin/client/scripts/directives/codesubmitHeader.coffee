app = angular.module 'codesubmit-admin'

app.directive 'codesubmitHeader', () ->
	return {
		restrict: 'A'
		templateUrl: 'views/codesubmitHeader'
		controller: 'codesubmitHeaderController'
	}
