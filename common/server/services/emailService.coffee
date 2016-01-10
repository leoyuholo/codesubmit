_ = require 'lodash'
nodemailer = require 'nodemailer'
xoauth2 = require 'xoauth2'

module.exports = ($) ->
	self = {}

	generator = xoauth2.createXOAuth2Generator
		user: $.config.email.auth.user
		clientId: $.config.email.auth.clientId
		clientSecret: $.config.email.auth.clientSecret
		refreshToken: $.config.email.auth.refreshToken

	if $.env.development
		transporter =
			sendMail: (mail, done) ->
				$.logger.log 'info', "Simulating sendMail %j", mail, {}
				done null
	else
		transporter = nodemailer.createTransport
			service: $.config.email.service
			auth:
				xoauth2: generator

	self.sendEmail = (to, subject, text, done) ->
		mail =
			to: to
			subject: subject
			text: text

		transporter.sendMail mail, done

	self.makeAdminResetPwSubject = (admin) ->
		"[codeSubmit] Password Reset"

	self.makeAdminResetPwText = (admin, plainPw) ->
		"""
		#{admin.username},\n\n
		Your password for codesubmit of ENGG1110 is reset to #{plainPw}\n\n
		Please log in #{$.config.origin.admin} and change it.\n\n
		codeSubmit
		"""

	self.makeStudentResetPwSubject = (student) ->
		"[codeSubmit] Password Reset"

	self.makeStudentResetPwText = (student, plainPw) ->
		"""
		#{student.username},\n\n
		Your password for codesubmit of ENGG1110 is reset to #{plainPw}\n\n
		Please log in #{$.config.origin.student} and change it.\n\n
		codeSubmit
		"""

	self.makeNewAdminSubject = (admin) ->
		"[codeSubmit] Welcome to codeSubmit!"

	self.makeNewAdminText = (admin, plainPw) ->
		"""
		#{admin.username},\n\n
		Your password is #{plainPw}\n\n
		Please log in #{$.config.origin.admin} and change it.\n\n
		codeSubmit
		"""

	self.makeNewStudentSubject = (student) ->
		"[codeSubmit] Welcome to codeSubmit!"

	self.makeNewStudentText = (student, plainPw) ->
		"""
		#{student.username},\n\n
		Welcome to codeSubmit of ENGG1110! codeSubmit is the place you write code and submit code for the assignments of ENGG1110.\n\n
		Take the password shown below and try it out. See you in the class!\n\n
		Your password is #{plainPw}\n\n
		Please log in #{$.config.origin.student} and change it.\n\n
		codeSubmit
		"""

	return self
