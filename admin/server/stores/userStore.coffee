$ = require '../globals'

User = $.models.Admin

module.exports = self = {}

self.findByEmail = (email, done) ->
	User.findOne {email: email}, done

self.create = (user, done) ->
	User.create user, done

self.update = (user, done) ->
	User.update user, user, done
