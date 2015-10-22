
module.exports = ($) ->
	self = {}

	self.list = () ->
		$.express.Router().get '/list', (req, res, done) ->
			$.services.adminService.list (err, admins) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					admins: admins

	self.findbyemail = () ->
		$.express.Router().get '/findbyemail/:email', (req, res, done) ->
			$.services.adminService.findByEmail req.params.email, (err, admin) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					admin: admin

	self.create = () ->
		$.express.Router().post '/create', (req, res, done) ->
			$.services.adminService.create req.body.admin, (err, admin) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					admin:
						username: admin.username

	self.deactivate = () ->
		$.express.Router().post '/deactivate', (req, res, done) ->
			$.services.adminService.deactivate req.body.admin.email, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.activate = () ->
		$.express.Router().post '/activate', (req, res, done) ->
			$.services.adminService.activate req.body.admin.email, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.resetpassword = () ->
		$.express.Router().post '/resetpassword', (req, res, done) ->
			$.services.adminService.resetPassword req.body.admin.email, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.changepassword = () ->
		$.express.Router().post '/changepassword', (req, res, done) ->
			oldPassword = req.body.oldPassword
			newPassword = req.body.newPassword

			$.services.adminService.changePassword req.user, oldPassword, newPassword, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	return self
