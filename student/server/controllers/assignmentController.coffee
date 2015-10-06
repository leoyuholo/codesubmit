
module.exports = ($) ->
	router = $.express.Router()

	router.get '/list', (req, res, done) ->
		$.services.assignmentService.list (err, assignments) ->
			return $.utils.onError done, err if err

			res.json
				success: true
				assignments: assignments

	return router
