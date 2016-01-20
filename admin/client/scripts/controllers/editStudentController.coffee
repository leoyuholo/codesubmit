app = angular.module 'codesubmit'

app.controller 'editStudentController', ($scope, studentService, messageService, student) ->

	$scope.editStudentMsg = {}
	$scope.student = student

	$scope.updateStudent = () ->
		studentService.update student, (err, data) ->
			return messageService.error $scope.editStudentMsg, err.message if err
			messageService.success $scope.editStudentMsg, 'Student updated.'
