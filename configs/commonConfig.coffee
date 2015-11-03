module.exports =
	origin: "127.0.0.1"
	port: 8080
	sessionSecret: 'codeSubmit secret'
	sessionName: 'codesubmit'
	redis:
		host: '192.168.0.111'
		port: 6379
	mongodb:
		host: '192.168.0.111'
		port: 27017
		db: 'codesubmit'
	rabbitmq:
		host: '192.168.0.111'
		port: 5672
		queues:
			submission: 'submission'
			runResult: 'runResult'
