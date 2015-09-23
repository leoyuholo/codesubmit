app = angular.module 'codesubmit-admin'

app.service 'studentService', ($http, $rootScope, urlService) ->
	self = {}

	self.listStudents = (done) ->
		urlService.get urlService.student.list(), done

	self.findByEmail = (email, done) ->
		urlService.get urlService.student.findByEmail(email), done

	self.createStudent = (student, done) ->
		payload =
			student:
				username: student.username
				email: student.email
				remarks: student.remarks

		urlService.post urlService.student.create(), payload, done

	self.deactivate = (student, done) ->
		payload =
			student:
				email: student.email

		urlService.post urlService.student.deactivate(), payload, done

	self.activate = (student, done) ->
		payload =
			student:
				email: student.email

		urlService.post urlService.student.activate(), payload, done

	self.resetPassword = (student, done) ->
		payload =
			student:
				email: student.email

		urlService.post urlService.student.resetPassword(), payload, done

	self.importByCsv = (csv, done) ->
		payload =
			csv: csv

		urlService.post urlService.student.importByCsv, payload, done

	return self
