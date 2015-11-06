app = angular.module 'codesubmit'

app.controller 'codesubmitEditorController', ($scope) ->

	editor = {}

	saveCode = () ->
		localStorage.setItem $scope.localStorageKey, editor.getValue() if $scope.localStorageKey

	saveCodeThrottled = _.throttle saveCode, 500

	aceLoaded = (_editor) ->
		editor = _editor

		editor.$blockScrolling = Infinity

		editor.setOptions
			minLines: $scope.aceOptions.minLines || 6
			maxLines: $scope.aceOptions.maxLines || Infinity

		editor.commands.addCommand
			name: 'save'
			bindKey:
				win: 'Ctrl-S'
				mac: 'Command-S'
			exec: saveCode

		editor.setReadOnly $scope.readOnly

	setAceOptions = () ->
		defaultOptions =
			onLoad: aceLoaded
			onChange: () ->
				$scope.ngModel = editor.getValue()
				saveCodeThrottled()

		$scope.aceOptions = _.defaults $scope.aceOptions || {}, defaultOptions

	setLanguage = () ->
		editor.getSession().setMode "ace/mode/#{if $scope.language == 'c' then 'c_cpp' else $scope.language}" if $scope.language

	$scope.$watch 'aceOptions', setAceOptions
	$scope.$watch 'language', setLanguage

	setAceOptions()
