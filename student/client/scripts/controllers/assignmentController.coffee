app = angular.module 'codesubmit'

app.controller 'AssignmentController', ($scope, $routeParams, assignmentService, redirectService, submissionService, messageService) ->

	editor = {}

	$scope.asgId = $routeParams.asgid
	$scope.assignmentDetailsMsg = {}
	$scope.assignmentSubmitMsg = {}
	$scope.assignment = {}

	$scope.submit = () ->
		code = editor.getValue()

		submissionService.submit $scope.assignment.asgId, code, (err, data) ->
			return messageService.error $scope.assignmentSubmitMsg, err.message if err
			messageService.success $scope.assignmentSubmitMsg, 'Submitted.'

			redirectService.redirectTo 'submission', $scope.assignment.asgId, $scope.assignment.name, data.submission.subId, 'latest'

	getCode = (asgId) ->
		localStorage.getItem "code/#{asgId}"

	setCode = (asgId, code) ->
		localStorage.setItem "code/#{asgId}", code

	initEditor = () ->
		editor = ace.edit 'editor'

		editor.$blockScrolling = Infinity

		editor.commands.addCommand
			name: 'save'
			bindKey:
				win: 'Ctrl-S'
				mac: 'Command-S'
			exec: (editor) ->
				saveCode()
				# messageService.success $scope.assignmentSubmitMsg, 'Saved locally.'

		saveCode = () ->
			setCode $scope.assignment.asgId, editor.getValue()
			setTimeout saveCode, 3000

		setTimeout saveCode, 3000

		# editor.setTheme 'ace/theme/monokai'
		# editor.getSession().setMode 'ace/mode/javascript'

	findAssignment = (asgId) ->
		assignmentService.findByAsgId asgId, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err

			$scope.assignment = data.assignment

			editor.getSession().setValue getCode($scope.asgId) || $scope.assignment?.codeTemplate || '// Enter your code here.\n'

	initEditor()
	findAssignment $scope.asgId
