_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = ($) ->
	student =
		email: {type: String, required: true, match: /.+@.+/}
		username: {type: String, required: true, match: /\w+/}
		password: {type: String, required: true, match: /[\w]+/}
		active: {type: Boolean, default: true}
		remarks: String

	studentSchema = new mongoose.Schema(student)

	studentSchema.index {email: 1}, {unique: true}

	studentSchema.static 'envelop', (doc) ->
		_.pick doc, _.keys student

	mongoose.model 'Student', studentSchema
