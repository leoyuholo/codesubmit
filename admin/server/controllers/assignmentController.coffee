$ = require '../globals'

router = $.express.Router()

router.get '/list', (req, res, done) ->
	$.services.assignmentService.list (err, assignments) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			assignments: assignments

router.get '/findbyasgid/:asgId', (req, res, done) ->
	$.services.assignmentService.findByAsgId req.params.asgId, (err, assignment) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			assignment: assignment

router.post '/create', (req, res, done) ->
	$.services.assignmentService.create req.body.assignment, (err, assignment) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			assignment: assignment

router.post '/update', (req, res, done) ->
	$.services.assignmentService.update req.body.assignment, (err, assignment) ->
		return $.utils.onError done, err if err

		res.json
			success: true

module.exports = router
