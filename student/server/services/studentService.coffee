_ = require 'lodash'

$ = require '../globals'

module.exports = self = {}

self.changePassword = (student, oldPassword, newPassword, done) ->
	return $.utils.onError done, new Error('Old password incorrect.') if student.password != oldPassword

	# TODO: hash newPassword
	student.password = newPassword
	$.stores.studentStore.update student, done
