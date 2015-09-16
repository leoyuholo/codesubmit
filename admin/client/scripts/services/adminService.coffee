app = angular.module 'codesubmit-admin'

app.service 'adminService', (urlService) ->
	self = {}

	self.update = (oldPassword, newPassword, done) ->
		return done new Error('Old password is empty') if !oldPassword
		return done new Error('New password is empty') if !newPassword

		payload =
			oldPassword: oldPassword
			newPassword: newPassword

		urlService.post urlService.updateAdmin(), payload, done

	return self
