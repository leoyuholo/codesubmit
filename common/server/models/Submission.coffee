mongoose = require 'mongoose'

module.exports = ($) ->
	submissionSchema = new mongoose.Schema(
		subId: {type: String, required: true}
		asgId: {type: String, required: true}
		email: {type: String, required: true}
		submitDt: {type: Date, required: true}
		code: {type: String, require: true}
		status: {type: String, default: 'Pending'}
		evaluateDt: Date
		results: Array
		score: {type: Number}
	)

	submissionSchema.index {subId: 1}

	submissionSchema.static 'envelop', (doc) ->
		return {
			subId: doc.subId
			asgId: doc.asgId
			email: doc.email
			submitDt: doc.submitDt
			code: doc.code
			status: doc.status
			evaluateDt: doc.evaluateDt
			results: doc.results
			score: doc.score
		}

	mongoose.model 'Submission', submissionSchema
