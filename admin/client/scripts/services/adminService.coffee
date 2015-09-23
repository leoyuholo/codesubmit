app = angular.module 'codesubmit-admin'

app.service 'adminService', (urlService) ->
	self = {}

	self.listAdmins = (done) ->
		urlService.get urlService.admin.list(), done

	self.findByEmail = (email, done) ->
		urlService.get urlService.admin.findByEmail(email), done

	self.createAdmin = (admin, done) ->
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

	self.update = (oldPassword, newPassword, done) ->
		return done new Error('Old password is empty') if !oldPassword
		return done new Error('New password is empty') if !newPassword

		payload =
			oldPassword: oldPassword
			newPassword: newPassword

		urlService.post urlService.admin.update(), payload, done

	return self
