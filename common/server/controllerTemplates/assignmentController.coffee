
module.exports = ($) ->
	self = {}

	self.listscorestats = () ->
		$.express.Router().get '/listscorestats', (req, res, done) ->
			$.services.assignmentService.listScoreStats (err, stats) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					stats: stats

	self.list = (customPath) ->
		$.express.Router().get (customPath || '/list'), (req, res, done) ->
			$.services.assignmentService.list (err, assignments) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					assignments: assignments

	self.listpublished = () ->
		$.express.Router().get '/listpublished', (req, res, done) ->
			$.services.assignmentService.listPublished (err, assignments) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					assignments: assignments

	self.findbyasgid = () ->
		$.express.Router().get '/findbyasgid/:asgId', (req, res, done) ->
			$.services.assignmentService.findByAsgId req.params.asgId, (err, assignment) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					assignment: assignment

	self.create = () ->
		$.express.Router().post '/create', (req, res, done) ->
			$.services.assignmentService.create req.body.assignment, (err, assignment) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					assignment: assignment

	self.update = () ->
		$.express.Router().post '/update', (req, res, done) ->
			$.services.assignmentService.update req.body.assignment, (err, assignment) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.remove = () ->
		$.express.Router().post '/remove', (req, res, done) ->
			$.services.assignmentService.remove req.body.assignment, (err, assignment) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	return self
