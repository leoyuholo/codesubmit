
module.exports = ($) ->
	router = $.express.Router()

	router.post '/changepassword', (req, res, done) ->
		oldPassword = req.body.oldPassword
		newPassword = req.body.newPassword

		$.services.studentService.changePassword req.user, oldPassword, newPassword, (err) ->
			return $.utils.onError done, err if err

			res.json
				success: true

	return router
