
module.exports = ($) ->
	router = $.express.Router()

	router.get '/jobstarted', (req, res, done) ->
		$.services.statusService.getJobStarted (err, count) ->
			return $.utils.onError done, err if err

			res.json
				success: true
				count: count

	router.get '/jobfinished', (req, res, done) ->
		$.services.statusService.getJobFinished (err, count) ->
			return $.utils.onError done, err if err

			res.json
				success: true
				count: count

	return router
