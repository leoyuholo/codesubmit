$ = require '../globals'

router = $.express.Router()

router.get '/list', (req, res, done) ->
	$.services.adminService.list (err, admins) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			admins: admins

router.get '/findbyemail/:email', (req, res, done) ->
	$.services.adminService.findByEmail req.params.email, (err, admin) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			admin: admin

router.post '/create', (req, res, done) ->
	$.services.adminService.create req.body.admin, (err, admin) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			admin:
				username: admin.username

router.post '/deactivate', (req, res, done) ->
	$.services.adminService.deactivate req.body.admin.email, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

router.post '/activate', (req, res, done) ->
	$.services.adminService.activate req.body.admin.email, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

router.post '/resetpassword', (req, res, done) ->
	$.services.adminService.resetPassword req.body.admin.email, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

router.post '/changepassword', (req, res, done) ->
	oldPassword = req.body.oldPassword
	newPassword = req.body.newPassword

	$.services.adminService.changePassword req.user, oldPassword, newPassword, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

module.exports = router
