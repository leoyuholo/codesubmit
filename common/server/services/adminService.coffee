_ = require 'lodash'

module.exports = ($) ->
	self = {}

	self.list = (done) ->
		$.stores.adminStore.list (err, admins) ->
			return $.utils.onError done, err if err
			done null, _.map admins, $.models.Admin.envelop

	self.findByEmail = (email, done) ->
		$.stores.adminStore.findByEmail email, (err, admin) ->
			return $.utils.onError done, err if err
			return $.utils.onError done, new Error("Admin with email: [#{email}] not found.") if !admin

			done null, $.models.Student.envelop admin

	self.create = (admin, done) ->
		plainPw = $.utils.rng.generatePw()
		# TODO: hash plainPw
		admin.password = plainPw

		$.stores.adminStore.create admin, (err) ->
			return $.utils.onError done, err if err

			emailSubject = $.services.emailService.makeNewUserSubject admin
			emailText = $.services.emailService.makeNewUserText admin, plainPw

			$.services.emailService.sendEmail admin.email, emailSubject, emailText, done

	self.deactivate = (email, done) ->
		$.stores.adminStore.findByEmail email, (err, admin) ->
			return $.utils.onError done, err if err

			admin.active = false
			$.stores.adminStore.update admin, done

	self.activate = (email, done) ->
		$.stores.adminStore.findByEmail email, (err, admin) ->
			return $.utils.onError done, err if err

			admin.active = true
			$.stores.adminStore.update admin, done

	self.resetPassword = (email, done) ->
		$.stores.adminStore.findByEmail email, (err, admin) ->
			return $.utils.onError done, err if err

			plainPw = $.utils.rng.generatePw()
			# TODO: hash plainPw
			admin.password = plainPw
			$.stores.adminStore.update admin, (err) ->
				return $.utils.onError done, err if err

				emailSubject = $.services.emailService.makeResetPwSubject admin
				emailText = $.services.emailService.makeResetPwText admin, plainPw

				$.services.emailService.sendEmail admin.email, emailSubject, emailText, done

	self.changePassword = (admin, oldPassword, newPassword, done) ->
		return $.utils.onError done, new Error('Old password incorrect.') if admin.password != oldPassword

		admin.password = newPassword
		$.stores.adminStore.update admin, done

	return self
