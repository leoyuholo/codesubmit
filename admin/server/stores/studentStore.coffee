$ = require '../globals'

Student = $.models.Student

module.exports = self = {}

self.findByEmail = (email, done) ->
	Student.findOne {email: email}, done

self.create = (user, done) ->
	Student.create user, done

self.update = (user, done) ->
	Student.update user, user, done
