_ = require 'lodash'
nodemailer = require 'nodemailer'

module.exports = ($) ->
	self = {}

	transporter = nodemailer.createTransport
		service: $.config.email.service
		auth:
			user: $.config.email.auth.user
			pass: $.config.email.auth.pass

	self.sendEmail = (to, subject, text, done) ->
		mail =
			to: 'yhlo@cse.cuhk.edu.hk' || to
			subject: subject
			text: text

		transporter.sendMail mail, done

	self.makeResetPwSubject = (user) ->
		"[codeSubmit] Password Reset "

	self.makeResetPwText = (user, plainPw) ->
		"#{user.username},\n\nYour password is reset to #{plainPw}\n\nPlease log in and change it.\n\ncodeSubmit"

	self.makeNewUserSubject = (user) ->
		"[codeSubmit] Welcome to codeSubmit!"

	self.makeNewUserText = (user, plainPw) ->
		"#{user.username},\n\nYour password is #{plainPw}\n\nPlease log in and change it.\n\ncodeSubmit"

	return self
