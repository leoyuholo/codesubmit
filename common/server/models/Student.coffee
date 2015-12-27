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

	attrKeys = _.without(_.keys(student), 'password')
	studentSchema.static 'envelop', (doc) ->
		_.pick doc, attrKeys

	mongoose.model 'Student', studentSchema
