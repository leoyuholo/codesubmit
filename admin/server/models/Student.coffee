mongoose = require 'mongoose'

studentSchema = new mongoose.Schema(
	email: String
	username: String
	password: String
)

studentSchema.index {email: 1}, {unique: true}

module.exports = mongoose.model 'Student', studentSchema
