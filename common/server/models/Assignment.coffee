mongoose = require 'mongoose'

module.exports = ($) ->
	assignmentSchema = new mongoose.Schema(
		asgId: {type: String, required: true}
		name: {type: String, required: true}
		startDt: {type: Date, required: true}
		dueDt: {type: Date, required: true}
		hardDueDt: {type: Date, required: true}
		submissionLimit: {type: Number, required: true, min: 1, max: 9999}
		penalty: {type: Number, required: true, min: 0, max: 100}
		sandboxConfigFileStorageKey: String
	)

	assignmentSchema.index {asgId: 1}, {unique: true}

	assignmentSchema.static 'envelop', (doc) ->
		return {
			asgId: doc.asgId
			name: doc.name
			startDt: doc.startDt
			dueDt: doc.dueDt
			hardDueDt: doc.hardDueDt
			submissionLimit: doc.submissionLimit
			penalty: doc.penalty
			sandboxConfigFileStorageKey: doc.sandboxConfigFileStorageKey
		}

	mongoose.model 'Assignment', assignmentSchema
