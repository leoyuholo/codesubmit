mongoose = require 'mongoose'

adminSchema = new mongoose.Schema(
	email: {type: String, required: true, match: /.+@.+/}
	username: {type: String, required: true, match: /\w+/}
	password: {type: String, required: true, match: /[\w]+/}
	active: {type: Boolean, default: true}
	remarks: String
)

adminSchema.index {email: 1}, {unique: true}

adminSchema.static 'envelop', (doc) ->
	return {
		username: doc.username
		email: doc.email
		active: doc.active
		remarks: doc.remarks
	}

module.exports = mongoose.model 'Admin', adminSchema
