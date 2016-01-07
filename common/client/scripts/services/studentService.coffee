app = angular.module 'codesubmit'

app.service 'studentService', (urlService, userService) ->
	self = {}

	self.list = (done) ->
		urlService.get urlService.student.list(), done

	self.findByEmail = (email, done) ->
		urlService.get urlService.student.findByEmail(email), done

	self.create = (student, done) ->
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

	self.changePassword = (oldPassword, newPassword, done) ->
		return done new Error('Old password is empty') if !oldPassword
		return done new Error('New password is empty') if !newPassword

		passwordInvalidMessage = userService.testPassword newPassword
		return done new Error(passwordInvalidMessage) if passwordInvalidMessage

		payload =
			oldPassword: userService.hashPw oldPassword
			newPassword: userService.hashPw newPassword

		urlService.post urlService.student.changePassword(), payload, done

	return self
