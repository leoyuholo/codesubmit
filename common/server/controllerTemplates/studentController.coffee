
module.exports = ($) ->
	self = {}

	self.list = () ->
		$.express.Router().get '/list', (req, res, done) ->
			$.services.studentService.list (err, students) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					students: students

	self.findbyemail = () ->
		$.express.Router().get '/findbyemail/:email', (req, res, done) ->
			$.services.studentService.findByEmail req.params.email, (err, student) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					student: student

	self.create = () ->
		$.express.Router().post '/create', (req, res, done) ->
			$.services.studentService.create req.body.student, (err, student) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.update = () ->
		$.express.Router().post '/update', (req, res, done) ->
			$.services.studentService.update req.body.student, (err, student) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.deactivate = () ->
		$.express.Router().post '/deactivate', (req, res, done) ->
			$.services.studentService.deactivate req.body.student.email, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.activate = () ->
		$.express.Router().post '/activate', (req, res, done) ->
			$.services.studentService.activate req.body.student.email, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.resetpassword = () ->
		$.express.Router().post '/resetpassword', (req, res, done) ->
			$.services.studentService.resetPassword req.body.student.email, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.changepassword = () ->
		$.express.Router().post '/changepassword', (req, res, done) ->
			oldPassword = req.body.oldPassword
			newPassword = req.body.newPassword

			$.services.studentService.changePassword req.user, oldPassword, newPassword, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	self.importbycsv = () ->
		$.express.Router().post '/importbycsv', (req, res, done) ->
			$.services.studentService.importByCsv req.body.csv, (err) ->
				return $.utils.onError done, err if err

				res.json
					success: true

	return self
