_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = ($) ->
	admin =
		email: {type: String, required: true, match: /.+@.+/}
		username: {type: String, required: true, match: /\w+/}
		password: {type: String, required: true}
		salt: {type: String, required: true}
		active: {type: Boolean, default: true}
		remarks: String

	adminSchema = new mongoose.Schema(admin)

	adminSchema.index {email: 1}, {unique: true}

	attrKeys = _.without _.keys(admin), ['password', 'salt']
	adminSchema.static 'envelop', (doc) ->
		_.pick doc, attrKeys

	mongoose.model 'Admin', adminSchema
