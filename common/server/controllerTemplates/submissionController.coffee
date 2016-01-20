
module.exports = ($) ->
	self = {}

	self.listscorestatsbyasgid = () ->
		$.express.Router().get '/listscorestatsbyasgid/:asgId', (req, res, done) ->
			asgId = req.params.asgId

			$.services.submissionService.listScoreStatsByAsgId asgId, (err, stats) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					stats: stats

	self.listscorestatsbyemail = () ->
		$.express.Router().get '/listscorestatsbyemail/:email', (req, res, done) ->
			email = req.params.email

			$.services.submissionService.listScoreStatsByEmail email, (err, stats) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					stats: stats

	self.listscorestats = () ->
		$.express.Router().get '/listscorestats', (req, res, done) ->
			$.services.submissionService.listScoreStats (err, stats) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					stats: stats

	self.findmyscorestatsbyasgid = () ->
		$.express.Router().get '/findmyscorestatsbyasgid/:asgId', (req, res, done) ->
			asgId = req.params.asgId
			email = req.user.email

			$.services.submissionService.findScoreStatsByAsgIdAndEmail asgId, email, (err, stat) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					stat: stat

	self.listmyscorestats = () ->
		$.express.Router().get '/listmyscorestats', (req, res, done) ->
			email = req.user.email

			$.services.submissionService.findScoreStatsByEmail email, (err, stats) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					stats: stats

	self.listbyasgid = () ->
		$.express.Router().get '/listbyasgid/:asgId', (req, res, done) ->
			asgId = req.params.asgId

			$.services.submissionService.list asgId, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.listbyemail = () ->
		$.express.Router().get '/listbyemail/:email', (req, res, done) ->
			email = req.params.email

			$.services.submissionService.list {email: email}, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.listbyasgidandemail = () ->
		$.express.Router().get '/listbyasgidandemail/:asgId/:email', (req, res, done) ->
			asgId = req.params.asgId
			email = req.params.email

			$.services.submissionService.list {asgId: asgId, email: email}, (err, submissions) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					submissions: submissions

	self.listminebyasgid = () ->
		$.express.Router().get '/listminebyasgid/:asgId', (req, res, done) ->
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
