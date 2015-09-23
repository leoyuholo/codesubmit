$ = require '../globals'

Admin = $.models.Admin

module.exports = self = {}

self.list = (done) ->
	Admin.find {}, done

self.findByEmail = (email, done) ->
	Admin.findOne {email: email}, done

self.create = (user, done) ->
	Admin.create user, done

self.update = (admin, done) ->
	Admin.update {email: admin.email}, admin, done
