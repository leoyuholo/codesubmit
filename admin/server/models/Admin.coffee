mongoose = require 'mongoose'

adminSchema = new mongoose.Schema(
	email: String
	username: String
	password: String
)

adminSchema.index {email: 1}, {unique: true}

module.exports = mongoose.model 'Admin', adminSchema
