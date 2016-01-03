_ = require 'lodash'

module.exports = ($) ->
	self = {}

	self.list = (done) ->
		$.stores.studentStore.list (err, students) ->
			return $.utils.onError done, err if err

			done null, _.map students, $.models.Student.envelop

	self.findByEmail = (email, done) ->
		$.stores.studentStore.findByEmail email, (err, student) ->
			return $.utils.onError done, err if err
			return $.utils.onError done, new Error("Student with email: [#{email}] not found.") if !student

			done null, $.models.Student.envelop student

	self.create = (student, done) ->
		plainPw = $.utils.rng.generatePw()
		# TODO: hash password
		student.password = plainPw

		$.stores.studentStore.create student, (err) ->
			return $.utils.onError done, err if err

			emailSubject = $.services.emailService.makeNewUserSubject student
			emailText = $.services.emailService.makeNewUserText student, plainPw

			$.services.emailService.sendEmail student.email, emailSubject, emailText, done

	self.deactivate = (email, done) ->
		$.stores.studentStore.findByEmail email, (err, student) ->
			return $.utils.onError done, err if err

			student.active = false
			$.stores.studentStore.update student, done

	self.activate = (email, done) ->
		$.stores.studentStore.findByEmail email, (err, student) ->
			return $.utils.onError done, err if err

			student.active = true
			$.stores.studentStore.update student, done

	self.resetPassword = (email, done) ->
		$.stores.studentStore.findByEmail email, (err, student) ->
			return $.utils.onError done, err if err

			plainPw = $.utils.rng.generatePw()
			# TODO: hash plainPw
			student.password = plainPw
			$.stores.studentStore.update student, (err) ->
				return $.utils.onError done, err if err

				emailSubject = $.services.emailService.makeResetPwSubject student
				emailText = $.services.emailService.makeResetPwText student, plainPw

				$.services.emailService.sendEmail student.email, emailSubject, emailText, done

	self.changePassword = (student, oldPassword, newPassword, done) ->
		return $.utils.onError done, new Error('Old password incorrect.') if student.password != oldPassword

		# TODO: hash newPassword
		student.password = newPassword
		$.stores.studentStore.update student, done

	self.importByCsv = (csv, done) ->
		return $.utils.onError done, 'Not yet implemented.'

	return self
