path = require 'path'

module.exports =
	origin: "127.0.0.1"
	port: 8080
	rootUser:
		email: 'codesubmit@gmail.com'
	logDir: path.join __dirname, '..', 'logs'
	# must match up the volume mount of worker docker
	fsNamespaceRoot: path.join '/', 'tmp', 'codesubmit'
	sessionSecret: 'codeSubmit secret'
	sessionName: 'codesubmit'
	email:
		service: 'gmail'
		auth:
			user: 'codesubmit@gmail.com'
			clientId: 'xxxxxx.apps.googleusercontent.com'
			clientSecret: 'xxxxxx'
			refreshToken: 'xxxxxx'
	redis:
		host: process.env.REDIS_PORT_6379_TCP_ADDR || 'localhost'
		port: process.env.REDIS_PORT_6379_TCP_PORT || 6379
	mongodb:
		host: process.env.MONGODB_PORT_27017_TCP_ADDR || 'localhost'
		port: process.env.MONGODB_PORT_27017_TCP_PORT || 27017
		db: 'codesubmit'
	rabbitmq:
		host: process.env.RABBITMQ_PORT_5672_TCP_ADDR || 'localhost'
		port: process.env.RABBITMQ_PORT_5672_TCP_PORT || 5672
		queues:
			submission: 'submission'
			runResult: 'runResult'
