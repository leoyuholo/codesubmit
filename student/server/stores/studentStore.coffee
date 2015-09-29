$ = require '../globals'

Student = $.models.Student

module.exports = self = {}

self.findByEmail = (email, done) ->
	Student.findOne {email: email}, done

self.update = (student, done) ->
	Student.update {email: student.email}, student, done
