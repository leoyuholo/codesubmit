app = angular.module 'codesubmit'

app.controller 'codesubmitEditorController', ($scope) ->

	editor = {}

	saveCode = () ->
		localStorage.setItem $scope.localStorageKey, editor.getValue() if $scope.localStorageKey

	aceLoaded = (_editor) ->
		editor = _editor

		editor.$blockScrolling = Infinity

		editor.commands.addCommand
			name: 'save'
			bindKey:
				win: 'Ctrl-S'
				mac: 'Command-S'
			exec: saveCode

		editor.setReadOnly $scope.readOnly

	$scope.aceOptions =
		onLoad: aceLoaded
		onChange: _.throttle saveCode, 500

	$scope.$watch 'language', () ->
		editor.getSession().setMode "ace/mode/#{if $scope.language == 'c' then 'c_cpp' else $scope.language}" if $scope.language
