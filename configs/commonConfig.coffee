path = require 'path'

module.exports =
	origin:
		admin: process.env.ADMIN_ORIGIN || "http://code.submit:8000"
		student: process.env.STUDENT_ORIGIN || "http://code.submit"
	port: 8080
	rootUser:
		email: 'codesubmit@gmail.com'
	logDir: path.join __dirname, '..', 'logs'
	# must match up the volume mount of worker docker
	fsNamespaceRoot: path.join '/', 'tmp', 'codesubmit'
	sessionSecret: 'codeSubmit secret'
	sessionName: 'codesubmit'
	email:
		smtp: 'smtp://mail.server.com'
		from: 'codesubmit@mail.server.com'
		service: 'gmail'
		auth:
			user: 'codesubmit@gmail.com'
			clientId: 'xxxxxx.apps.googleusercontent.com'
			clientSecret: 'xxxxxx'
			refreshToken: 'xxxxxx'
		template:
			admin:
				newUser:
					subject: '[codeSubmit] Welcome to codeSubmit!'
					text:
						"""
						<%= username%>,\n
						Your password is <%= password%>\n
						Please log in <%= url%> and change it.\n
						codesubmit
						"""
				resetPw:
					subject: '[codeSubmit] Password Reset'
					text:
						"""
						<%= username%>,\n
						Your password for codesubmit of ENGG1110 is reset to <%= password%>\n
						Please log in <%= url%> and change it.\n
						codesubmit
						"""
			student:
				newUser:
					subject: '[codeSubmit] Welcome to codeSubmit!'
					text:
						"""
						<%= username%>,\n
						Your password is <%= password%>\n
						Please log in <%= url%> and change it.\n
						codesubmit
						"""
				resetPw:
					subject: '[codeSubmit] Password Reset'
					text:
						"""
						<%= username%>,\n
						Your password for codesubmit of ENGG1110 is reset to <%= password%>\n
						Please log in <%= url%> and change it.\n
						codesubmit
						"""
	mongodb:
		host: process.env.MONGODB_PORT_27017_TCP_ADDR || process.env.HOST_IP  || 'localhost'
		port: process.env.MONGODB_PORT_27017_TCP_PORT || 27017
		db: 'codesubmit'
	rabbitmq:
		host: process.env.RABBITMQ_PORT_5672_TCP_ADDR || process.env.HOST_IP  || 'localhost'
		port: process.env.RABBITMQ_PORT_5672_TCP_PORT || 5672
		queues:
			submission: 'submission'
			runResult: 'runResult'
