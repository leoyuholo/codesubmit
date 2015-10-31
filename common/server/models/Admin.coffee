_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = ($) ->
	admin =
		email: {type: String, required: true, match: /.+@.+/}
		username: {type: String, required: true, match: /\w+/}
		password: {type: String, required: true, match: /[\w]+/}
		active: {type: Boolean, default: true}
		remarks: String

	adminSchema = new mongoose.Schema(admin)

	adminSchema.index {email: 1}, {unique: true}

	adminSchema.static 'envelop', (doc) ->
		_.pick doc, _.keys admin

	mongoose.model 'Admin', adminSchema
