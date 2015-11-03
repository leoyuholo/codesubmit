_ = require 'lodash'

mongoose = require 'mongoose'

module.exports = ($) ->
	status = ['pending', 'running', 'error', 'evaluated']

	submission =
		subId: {type: String, required: true}
		asgId: {type: String, required: true}
		email: {type: String, required: true}
		submitDt: {type: Date, required: true}
		code: {type: String, require: true}
		status: {type: String, enum: status, default: 'pending'}
		evaluateDt: Date
		results: [
			{
				testCaseName: String
				status: {type: String, enum: status, default: 'pending'}
				correct: Boolean
				message: String
				compileErrorMessage: String
				hint: String
				time: Number
				memory: Number
			}
		]
		score: {type: Number}

	submissionSchema = new mongoose.Schema(submission)

	submissionSchema.index {subId: 1}, {unique: true}
	submissionSchema.index {asgId: 1}
	submissionSchema.index {email: 1}

	submissionSchema.static 'envelop', (doc) ->
		_.pick doc, _.keys submission

	submissionSchema.post 'save', (doc, done) ->
		$.services.submissionService.updateScoreStats doc.subId, done

	mongoose.model 'Submission', submissionSchema
