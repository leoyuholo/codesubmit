_ = require 'lodash'

$ = require '../globals'

module.exports = self = {}

self.list = (done) ->
	$.stores.studentStore.list (err, students) ->
		return $.utils.onError done, err if err

		done null, _.map students, $.models.Student.envelop

self.findByEmail = (email, done) ->
	$.stores.studentStore.findByEmail email, (err, student) ->
		return $.utils.onError done, err if err
		return $.utils.onError done, new Error("Student with email: [#{email}] not found.") if !student

		done null, $.models.Student.envelop student

self.create = (student, done) ->
	student.password = $.utils.rng.generatePw()

	$.stores.studentStore.create student, (err) ->
		return $.utils.onError done, err if err

		# send email
		done null

self.deactivate = (email, done) ->
	$.stores.studentStore.findByEmail email, (err, student) ->
		return $.utils.onError done, err if err

		student.active = false
		$.stores.studentStore.update student, done

self.activate = (email, done) ->
	$.stores.studentStore.findByEmail email, (err, student) ->
		return $.utils.onError done, err if err

		student.active = true
		$.stores.studentStore.update student, done

self.resetPassword = (email, done) ->
	$.stores.studentStore.findByEmail email, (err, student) ->
		return $.utils.onError done, err if err

		student.password = $.utils.rng.generatePw()
		$.stores.studentStore.update student, (err) ->
			return $.utils.onError done, err if err

			# send email
			done null

self.importByCsv = (csv, done) ->
	return $.utils.onError done, 'Not yet implemented.'
