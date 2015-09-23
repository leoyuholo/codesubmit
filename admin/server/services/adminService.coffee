_ = require 'lodash'

$ = require '../globals'

module.exports = self = {}

self.list = (done) ->
	$.stores.adminStore.list (err, admins) ->
		return $.utils.onError done, err if err
		done null, _.map admins, $.models.Admin.envelop

self.findByEmail = (email, done) ->
	$.stores.adminStore.findByEmail email, (err, admin) ->
		return $.utils.onError done, err if err
		return $.utils.onError done, new Error("Admin with email: [#{email}] not found.") if !admin

		done null, $.models.Student.envelop admin

self.create = (admin, done) ->
	admin.password = $.utils.rng.generatePw()

	$.stores.adminStore.create admin, (err) ->
		return $.utils.onError done, err if err

		# send email
		done null, admin

self.deactivate = (email, done) ->
	$.stores.adminStore.findByEmail email, (err, admin) ->
		return $.utils.onError done, err if err

		admin.active = false
		$.stores.adminStore.update admin, done

self.activate = (email, done) ->
	$.stores.adminStore.findByEmail email, (err, admin) ->
		return $.utils.onError done, err if err

		admin.active = true
		$.stores.adminStore.update admin, done

self.resetPassword = (email, done) ->
	$.stores.adminStore.findByEmail email, (err, admin) ->
		return $.utils.onError done, err if err

		admin.password = $.utils.rng.generatePw()
		$.stores.adminStore.update admin, (err) ->
			return $.utils.onError done, err if err

			# send email
			done null

self.changePassword = (user, oldPassword, newPassword, done) ->
	return $.utils.onError done, new Error('Old password incorrect.') if user.password != oldPassword

	$.stores.adminStore.update user.email, {password: newPassword}, done
