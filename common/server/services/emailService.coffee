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

	self.newAdminSubjectTemplate = _.template $.config.email.template.admin.newUser.subject
	self.newAdminTextTemplate = _.template $.config.email.template.admin.newUser.text
	self.adminResetPwSubjectTemplate = _.template $.config.email.template.admin.resetPw.subject
	self.adminResetPwTextTemplate = _.template $.config.email.template.admin.resetPw.text
	self.newStudentSubjectTemplate = _.template $.config.email.template.student.newUser.subject
	self.newStudentTextTemplate = _.template $.config.email.template.student.newUser.text
	self.studentResetPwSubjectTemplate = _.template $.config.email.template.student.resetPw.subject
	self.studentResetPwTextTemplate = _.template $.config.email.template.student.resetPw.text

	self.makeNewAdminSubject = (admin) ->
		self.newAdminSubjectTemplate {username: admin.username}

	self.makeNewAdminText = (admin, plainPw) ->
		self.newAdminTextTemplate
			username: admin.username
			password: plainPw
			url: $.config.origin.admin

	self.makeAdminResetPwSubject = (admin) ->
		self.adminResetPwSubjectTemplate {username: admin.username}

	self.makeAdminResetPwText = (admin, plainPw) ->
		self.adminResetPwTextTemplate
			username: admin.username
			password: plainPw
			url: $.config.origin.admin

	self.makeNewStudentSubject = (student) ->
		self.newStudentSubjectTemplate {username: student.username}

	self.makeNewStudentText = (student, plainPw) ->
		self.newStudentTextTemplate
			username: student.username
			password: plainPw
			url: $.config.origin.student

	self.makeStudentResetPwSubject = (student) ->
		self.newStudentSubjectTemplate {username: student.username}

	self.makeStudentResetPwText = (student, plainPw) ->
		self.newStudentTextTemplate
			username: student.username
			password: plainPw
			url: $.config.origin.student

	self.sendEmail = (to, subject, text, done) ->
		mail =
			to: to
			subject: subject
			text: text

		transporter.sendMail mail, done

	return self
