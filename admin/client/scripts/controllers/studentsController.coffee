app = angular.module 'codesubmit-admin'

app.controller 'StudentsController', ($scope, studentService, messageService) ->

	defaultStudent =
		username: ''
		email: ''
		remarks: ''

	$scope.students = []
	$scope.studentListMsg = {}
	$scope.newStudents = []
	$scope.studentCreateMsg = {}

	$scope.listStudents = () ->
		$scope.studentListMsg.refreshing = true
		studentService.listStudents (err, data) ->
			$scope.studentListMsg.refreshing = false
			return messageService.error $scope.studentListMsg, err.message if err

			$scope.students = data.students

	$scope.deactivate = (student) ->
		console.log "deactivate"
		return

	$scope.resetPassword = (student) ->
		console.log "resetPassword"
		return

	$scope.createStudent = (student) ->
		student.status = 'Adding'
		studentService.createStudent student, (err) ->
			if err
				delete student.status
				return messageService.error $scope.studentCreateMsg, err.message

			messageService.success $scope.studentCreateMsg, 'Student added.'
			student.status = 'Added'

	$scope.importStudent = (text) ->
		console.log "importStudent"
		return

	$scope.addEmptyStudent = () ->
		$scope.newStudents.push _.cloneDeep defaultStudent

	$scope.listStudents()
	$scope.addEmptyStudent()
