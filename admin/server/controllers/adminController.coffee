$ = require '../globals'

router = $.express.Router()

router.get '/list', (req, res, done) ->
	$.services.adminService.list (err, admins) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			admins: admins

router.post '/create', (req, res, done) ->
	$.services.adminService.create req.body.admin, (err, admin) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			admin:
				username: admin.username

router.post '/update', (req, res, done) ->
	oldPassword = req.body.oldPassword
	newPassword = req.body.newPassword

	$.services.adminService.changePassword req.user, oldPassword, newPassword, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

module.exports = router
