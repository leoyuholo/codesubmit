
module.exports = ($) ->
	self = {}

	self.list = () ->
		$.express.Router().get '/list', (req, res, done) ->
			$.services.assignmentService.list (err, assignments) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					assignments: assignments

	self.listwithmystats = (customPath) ->
		$.express.Router().get (customPath || '/listwithmystats'), (req, res, done) ->
			$.services.assignmentService.listWithMyStats req.user.email, (err, assignments) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					assignments: assignments

	self.listpublishedwithmystats = () ->
		$.express.Router().get '/listpublishedwithmystats', (req, res, done) ->
			$.services.assignmentService.listPublishedWithMyStats req.user.email, (err, assignments) ->
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

	return self
