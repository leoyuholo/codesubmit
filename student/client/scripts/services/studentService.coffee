app = angular.module 'codesubmit-student'

app.service 'studentService', (urlService) ->
	self = {}

	self.changePassword = (oldPassword, newPassword, done) ->
		return done new Error('Old password is empty') if !oldPassword
		return done new Error('New password is empty') if !newPassword

		payload =
			oldPassword: oldPassword
			newPassword: newPassword

		urlService.post urlService.student.changePassword(), payload, done

	return self
