_ = require 'lodash'

$ = require '../globals'

module.exports = self = {}

self.list = (done) ->
	$.stores.adminStore.list (err, admins) ->
		return $.utils.onError done, err if err
		done null, _.map admins, (s) ->
			return {
				username: s.username
				email: s.email
				remarks: s.remarks
			}

self.create = (admin, done) ->
	admin.password = 'demo'

	$.stores.adminStore.create admin, (err) ->
		return $.utils.onError done, err if err
		done null, admin

self.changePassword = (user, oldPassword, newPassword, done) ->
	return $.utils.onError done, new Error('Old password incorrect.') if user.password != oldPassword

	$.stores.adminStore.update user.email, {password: newPassword}, done
