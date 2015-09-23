mongoose = require 'mongoose'

submissionSchema = new mongoose.Schema(
	subId: {type: String, required: true}
	asgId: {type: String, required: true}
	email: {type: String, required: true}
	submitDt: {type: Date, required: true}
)

submissionSchema.index {asgId: 1}

submissionSchema.static 'envelop', (doc) ->
	return {
		subId: doc.subId
		asgId: doc.asgId
		email: doc.email
		submitDt: doc.submitDt
	}

module.exports = mongoose.model 'Submission', submissionSchema
