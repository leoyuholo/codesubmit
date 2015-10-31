_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = ($) ->
	languages = ['c', 'javascript', 'python', 'ruby']

	assignment =
		asgId: {type: String, required: true}
		name: {type: String, required: true}
		startDt: {type: Date, required: true}
		dueDt: {type: Date, required: true}
		hardDueDt: {type: Date, required: true}
		submissionLimit: {type: Number, required: true, min: 1, max: 1000}
		penalty: {type: Number, required: true, min: 0, max: 100}
		sandboxConfig: {
			commandTimeoutMs: {type: Number, min: 0, max: 4200000, default: 2000}
			timeLimitS: {type: Number, min: 0, max: 3600, default: 1}
			memoryLimitMB: {type: Number, min: 0, max: 1024, default: 32}
			outputLimitKB: {type: Number, min: 0, max: 102400, default: 10240}
			errorToleranceLevel: {type: Number, min: 0, max: 2, default: 1}
			strictCompare: {type: Boolean, default: false}
			language: {type: String, enum: languages, default: 'c'}
			codeFilename: {type: String, default: 'code.c'}
			compileCommand: {type: String, default: 'gcc -lm code.c -o code'}
			executableFilename: {type: String, default: 'code'}
			testCaseNames: [String]
		}
		testCaseFileStorageKey: String
		description: String
		codeTemplate: {type: String, default: '// Enter your code here.'}
		sampleInput: {type: String, default: ''}

	assignmentSchema = new mongoose.Schema(assignment)

	assignmentSchema.index {asgId: 1}, {unique: true}

	assignmentSchema.static 'envelop', (doc) ->
		_.pick doc, _.keys assignment

	mongoose.model 'Assignment', assignmentSchema
