$ = require '../globals'

Admin = $.models.Admin

module.exports = self = {}

self.findByEmail = (email, done) ->
	Admin.findOne {email: email}, done

self.create = (user, done) ->
	Admin.create user, done

self.update = (email, admin, done) ->
	Admin.update {email: email}, admin, done
