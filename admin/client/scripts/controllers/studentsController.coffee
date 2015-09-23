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

	$scope.deactivate = (student, index) ->
		studentService.deactivate student, (err) ->
			return messageService.error $scope.studentListMsg, err.message if err
			messageService.success $scope.studentListMsg, 'Student deactivated.'

			studentService.findByEmail student.email, (err, data) ->
				return messageService.error $scope.studentListMsg, err.message if err

				$scope.students[index] = data.student

	$scope.activate = (student, index) ->
		studentService.activate student, (err) ->
			return messageService.error $scope.studentListMsg, err.message if err
			messageService.success $scope.studentListMsg, 'Student activated.'

			studentService.findByEmail student.email, (err, data) ->
				return messageService.error $scope.studentListMsg, err.message if err

				$scope.students[index] = data.student

	$scope.resetPassword = (student) ->
		studentService.resetPassword student, (err) ->
			return messageService.error $scope.studentListMsg, err.message if err
			messageService.success $scope.studentListMsg, 'Password reseted.'

	$scope.createStudent = (student) ->
		student.status = 'Adding'
		studentService.createStudent student, (err) ->
			if err
				delete student.status
				return messageService.error $scope.studentCreateMsg, err.message

			messageService.success $scope.studentCreateMsg, 'Student added.'
			student.status = 'Added'

	$scope.importStudents = (text) ->
		studentService.importByCsv text, (err) ->
			return messageService.error $scope.studentListMsg, err.message if err
			messageService.success $scope.studentListMsg, 'Students imported.'

	$scope.addEmptyStudent = () ->
		$scope.newStudents.push _.cloneDeep defaultStudent

	$scope.listStudents()
	$scope.addEmptyStudent()
