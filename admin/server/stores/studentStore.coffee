$ = require '../globals'

Student = $.models.Student

module.exports = self = {}

self.list = (done) ->
	Student.find {}, done

self.findByEmail = (email, done) ->
	Student.findOne {email: email}, done

self.create = (student, done) ->
	Student.create student, done

self.update = (user, done) ->
	Student.update user, user, done
