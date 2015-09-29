app = angular.module 'codesubmit-student'

app.controller 'AssignmentsController', ($scope, assignmentService, submissionService, messageService) ->

	$scope.assignments = []
	$scope.assignmentListMsg = {}

	$scope.listAssignments = () ->
		assignmentService.listAssignments (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			$scope.assignments = data.assignments

	$scope.listAssignments()

	editors = []
	$scope.assignmentSubmitMsg = []

	$scope.initEditor = (index) ->
		editors[index] = ace.edit("assignmentListEditor-#{index}") if !editors[index]
		editor = editors[index]
		# editor.setTheme("ace/theme/monokai")
		# editor.getSession().setMode("ace/mode/javascript")

		$scope.assignmentSubmitMsg[index] = {}

	$scope.submitAssignment = (index) ->
		assignment = $scope.assignments[index]
		editor = editors[index]

		code = editor.getValue()

		submissionService.submit assignment.asgId, code, (err) ->
			return messageService.error $scope.assignmentSubmitMsg[index], err.message if err
			return messageService.success $scope.assignmentSubmitMsg[index], 'Submitted.'
