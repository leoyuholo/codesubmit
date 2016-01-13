
module.exports = ($) ->
	self = {}

	self.listScoreStats = () ->
		$.express.Router().get '/listscorestats', (req, res, done) ->
			$.services.submissionService.listScoreStats (err, stats) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					stats: stats

	self.listByEmail = () ->
		$.express.Router().get '/list/:asgId/:email', (req, res, done) ->
			asgId = req.params.asgId
			email = req.params.email

			$.services.submissionService.list {asgId: asgId, email: email}, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.list = () ->
		$.express.Router().get '/list/:asgId', (req, res, done) ->
			asgId = req.params.asgId

			$.services.submissionService.list asgId, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.listmine = () ->
		$.express.Router().get '/listmine/:asgId', (req, res, done) ->
			asgId = req.params.asgId
			email = req.user.email

			$.services.submissionService.list {asgId: asgId, email: email}, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.findBySubId = () ->
		$.express.Router().get '/findbysubid/:subId', (req, res, done) ->
			subId = req.params.subId

			$.services.submissionService.findBySubId subId, (err, submission) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submission: submission

	self.findminebysubid = () ->
		$.express.Router().get '/findminebysubid/:subId', (req, res, done) ->
			subId = req.params.subId
			email = req.user.email

			$.services.submissionService.findBySubId {subId: subId, email: email}, (err, submission) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submission: submission

	self.run = () ->
		$.express.Router().post '/run/:asgId', (req, res, done) ->
			asgId = req.params.asgId
			code = req.body.code
			input = req.body.input
			output = req.body.output

			$.services.submissionService.run req.user, asgId, code, input, output, (err, runResult) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					runResult: runResult

	self.submit = () ->
		$.express.Router().post '/submit/:asgId', (req, res, done) ->
			asgId = req.params.asgId
			code = req.body.code

			$.services.submissionService.submit req.user, asgId, code, (err, submission) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submission: submission

	return self
