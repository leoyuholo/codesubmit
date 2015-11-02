app = angular.module 'codesubmit'

app.directive 'codesubmitEditor', () ->
	return {
		restrict: 'E'
		templateUrl: 'views/codesubmitEditor'
		scope:
			localStorageKey: '='
			language: '='
			readOnly: '='
			ngModel: '='
			aceOptions: '='
		controller: 'codesubmitEditorController'
	}
