app = angular.module 'codesubmit'

app.service 'adminService', (urlService) ->
	self = {}

	self.list = (done) ->
		urlService.get urlService.admin.list(), done

	self.findByEmail = (email, done) ->
		urlService.get urlService.admin.findByEmail(email), done

	self.create = (admin, done) ->
		payload =
			admin:
				username: admin.username
				email: admin.email
				remarks: admin.remarks

		urlService.post urlService.admin.create(), payload, done

	self.deactivate = (admin, done) ->
		payload =
			admin:
				email: admin.email

		urlService.post urlService.admin.deactivate(), payload, done

	self.activate = (admin, done) ->
		payload =
			admin:
				email: admin.email

		urlService.post urlService.admin.activate(), payload, done

	self.resetPassword = (admin, done) ->
		payload =
			admin:
				email: admin.email

		urlService.post urlService.admin.resetPassword(), payload, done

	self.changePassword = (oldPassword, newPassword, done) ->
		return done new Error('Old password is empty') if !oldPassword
		return done new Error('New password is empty') if !newPassword

		payload =
			oldPassword: oldPassword
			newPassword: newPassword

		urlService.post urlService.admin.changePassword(), payload, done

	return self
