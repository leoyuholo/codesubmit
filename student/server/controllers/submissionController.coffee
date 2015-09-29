$ = require '../globals'

router = $.express.Router()

router.post '/submit/:asgId', (req, res, done) ->
	asgId = req.params.asgId
	code = req.body.code

	$.services.submissionService.submit req.user, asgId, code, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

module.exports = router
