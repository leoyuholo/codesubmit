_ = require 'lodash'
mongoose = require 'mongoose'
validators = require 'mongoose-validators'

module.exports = ($) ->
	languages = ['c', 'javascript', 'python', 'ruby']

	assignment =
		asgId: {type: String, required: true}
		name: {type: String, required: true}
		startDt: {type: Date, required: true}
		dueDt: {type: Date, required: true}
		hardDueDt: {type: Date, required: true}
		submissionLimit: {type: Number, required: true, min: 1, max: 1000, validate: validators.isInt()}
		penalty: {type: Number, required: true, min: 0, max: 100, validate: validators.isInt()}
		sandboxConfig: {
			commandTimeoutMs: {type: Number, min: 0, max: 4200000, default: 2000, validate: validators.isInt()}
			timeLimitS: {type: Number, min: 0, max: 3600, default: 1, validate: validators.isInt()}
			memoryLimitMB: {type: Number, min: 0, max: 1024, default: 32, validate: validators.isInt()}
			outputLimitKB: {type: Number, min: 0, max: 102400, default: 10240, validate: validators.isInt()}
			errorToleranceLevel: {type: Number, min: 0, max: 2, default: 1, validate: validators.isInt()}
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
		sampleOutput: {type: String, default: ''}

	assignmentSchema = new mongoose.Schema(assignment)

	assignmentSchema.index {asgId: 1}, {unique: true}

	attrKeys = _.keys assignment
	assignmentSchema.static 'envelop', (doc) ->
		_.pick doc, attrKeys

	mongoose.model 'Assignment', assignmentSchema
