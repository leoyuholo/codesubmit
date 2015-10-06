mongoose = require 'mongoose'

module.exports = ($) ->
	submissionSchema = new mongoose.Schema(
		subId: {type: String, required: true}
		asgId: {type: String, required: true}
		email: {type: String, required: true}
		submitDt: {type: Date, required: true}
		code: {type: String, require: true}
	)

	submissionSchema.index {subId: 1}

	submissionSchema.static 'envelop', (doc) ->
		return {
			subId: doc.subId
			asgId: doc.asgId
			email: doc.email
			submitDt: doc.submitDt
		}

	mongoose.model 'Submission', submissionSchema
