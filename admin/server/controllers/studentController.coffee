$ = require '../globals'

router = $.express.Router()

router.get '/list', (req, res, done) ->
	$.services.studentService.list (err, students) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			students: students

router.post '/create', (req, res, done) ->
	$.services.studentService.create req.body.student, (err, student) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			student:
				username: student.username

module.exports = router
