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

	self.makeResetPwSubject = (user) ->
		"[codeSubmit] Password Reset "

	self.makeResetPwText = (user, plainPw) ->
		"#{user.username},\n\nYour password is reset to #{plainPw}\n\nPlease log in and change it.\n\ncodeSubmit"

	self.makeNewUserSubject = (user) ->
		"[codeSubmit] Welcome to codeSubmit!"

	self.makeNewUserText = (user, plainPw) ->
		"#{user.username},\n\nYour password is #{plainPw}\n\nPlease log in and change it.\n\ncodeSubmit"

	return self
