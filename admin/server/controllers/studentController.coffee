$ = require '../globals'

router = $.express.Router()

router.get '/list', (req, res, done) ->
	$.services.studentService.list (err, students) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			students: students

router.get '/findbyemail/:email', (req, res, done) ->
	$.services.studentService.findByEmail req.params.email, (err, student) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			student: student

router.post '/create', (req, res, done) ->
	$.services.studentService.create req.body.student, (err, student) ->
		return $.utils.onError done, err if err

		res.json
			success: true
			student:
				username: student.username

router.post '/deactivate', (req, res, done) ->
	$.services.studentService.deactivate req.body.student.email, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

router.post '/activate', (req, res, done) ->
	$.services.studentService.activate req.body.student.email, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

router.post '/resetpassword', (req, res, done) ->
	$.services.studentService.resetPassword req.body.student.email, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

router.post 'importbycsv', (req, res, done) ->
	$.services.studentService.importByCsv req.body.csv, (err) ->
		return $.utils.onError done, err if err

		res.json
			success: true

module.exports = router
