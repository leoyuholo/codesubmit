$ = require '../globals'

router = $.express.Router()

router.post '/update', (req, res, next) ->
	oldPassword = req.body.oldPassword
	newPassword = req.body.newPassword

	$.services.adminService.changePassword req.user, oldPassword, newPassword, (err) ->
		return next err if err

		res.json
			success: true

module.exports = router
