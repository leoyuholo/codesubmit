mongoose = require 'mongoose'

module.exports = ($) ->
	studentSchema = new mongoose.Schema(
		email: {type: String, required: true, match: /.+@.+/}
		username: {type: String, required: true, match: /\w+/}
		password: {type: String, required: true, match: /[\w]+/}
		active: {type: Boolean, default: true}
		remarks: String
	)

	studentSchema.index {email: 1}, {unique: true}

	studentSchema.static 'envelop', (doc) ->
		return {
			username: doc.username
			email: doc.email
			active: doc.active
			remarks: doc.remarks
		}

	mongoose.model 'Student', studentSchema
