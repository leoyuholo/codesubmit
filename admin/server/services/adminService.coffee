$ = require '../globals'

module.exports = self = {}

self.changePassword = (user, oldPassword, newPassword, done) ->
	return $.utils.onError done, new Error('Old password incorrect.') if user.password != oldPassword

	$.stores.adminStore.update user.email, {password: newPassword}, done
