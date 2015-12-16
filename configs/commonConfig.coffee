path = require 'path'

module.exports =
	origin: "127.0.0.1"
	port: 8080
	logDir: path.join __dirname, '..', 'logs'
	# must match up the volume mount of worker docker
	fsNamespaceRoot: path.join '/', 'tmp', 'codesubmit'
	sessionSecret: 'codeSubmit secret'
	sessionName: 'codesubmit'
	redis:
		host: process.env.host_ip || 'localhost'
		port: 6379
	mongodb:
		host: process.env.host_ip || 'localhost'
		port: 27017
		db: 'codesubmit'
	rabbitmq:
		host: process.env.host_ip || 'localhost'
		port: 5672
		queues:
			submission: 'submission'
			runResult: 'runResult'
