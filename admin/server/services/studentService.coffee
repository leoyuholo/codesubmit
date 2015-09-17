_ = require 'lodash'

$ = require '../globals'

module.exports = self = {}

self.list = (done) ->
	$.stores.studentStore.list (err, students) ->
		return $.utils.onError done, err if err
		done null, _.map students, (s) ->
			return {
				username: s.username
				email: s.email
				remarks: s.remarks
			}

self.create = (student, done) ->
	student.password = 'demo'

	$.stores.studentStore.create student, (err) ->
		return $.utils.onError done, err if err
		done null, student
