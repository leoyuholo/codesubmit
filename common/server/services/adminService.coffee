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

		$.utils.rng.hashPlainPw admin.email, plainPw, (err, hash, salt) ->
			return $.utils.onError done, err if err

			admin.password = hash
			admin.salt = salt

			$.stores.adminStore.create admin, (err) ->
				return $.utils.onError done, err if err

				emailSubject = $.services.emailService.makeNewAdminSubject admin
				emailText = $.services.emailService.makeNewAdminText admin, plainPw

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

			$.utils.rng.hashPlainPw admin.email, plainPw, (err, hash, salt) ->
				return $.utils.onError done, err if err

				admin.password = hash
				admin.salt = salt

				$.stores.adminStore.update admin, (err) ->
					return $.utils.onError done, err if err

					emailSubject = $.services.emailService.makeAdminResetPwSubject admin
					emailText = $.services.emailService.makeAdminResetPwText admin, plainPw

					$.services.emailService.sendEmail admin.email, emailSubject, emailText, done

	self.changePassword = (admin, oldPassword, newPassword, done) ->
		$.utils.rng.verifyPw admin.password, admin.salt, oldPassword, (err, valid) ->
			return $.utils.onError done, err if err
			return $.utils.onError done, new Error('Old password incorrect.') if !valid

			$.utils.rng.secureHashPw newPassword, (err, hash, salt) ->
				return $.utils.onError done, err if err

				admin.password = hash
				admin.salt = salt

				$.stores.adminStore.update admin, done

	return self
