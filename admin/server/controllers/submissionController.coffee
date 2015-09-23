$ = require '../globals'

router = $.express.Router()

router.get '/list/:asgId', (req, res, done) ->
	asgId = req.params.asgId

	$.services.submissionService.list asgId, (err, submissions) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			submissions: submissions

module.exports = router
