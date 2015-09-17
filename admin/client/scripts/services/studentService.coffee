app = angular.module 'codesubmit-admin'

app.service 'studentService', ($http, $rootScope, urlService) ->
	self = {}

	self.listStudents = (done) ->
		urlService.get urlService.listStudents(), done

	self.createStudent = (student, done) ->
		payload =
			student:
				username: student.username
				email: student.email
				remarks: student.remarks

		urlService.post urlService.createStudent(), payload, done

	return self
