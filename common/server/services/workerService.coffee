path = require 'path'

_ = require 'lodash'
async = require 'async'
fse = require 'fs-extra'

module.exports = ($) ->
	self = {}

	makeRunResult = (result, testCaseName) ->
		runResult = _.pick result, [
			'errorMessage'
			'hint'
			'compileErrorMessage'
			'time'
			'memory'
			'input'
			'output'
			'expectedOutput'
		]

		runResult.testCaseName = if testCaseName then testCaseName else 'run'
		runResult.status = result.status || 'evaluated'

		if result.ok && result.matchExpected != undefined
			runResult.correct = result.matchExpected
			if runResult.correct
				runResult.message = 'Accepted'
			else
				runResult.message = 'Wrong Answer'
		else
			runResult.message = result.message

		return runResult


	processSubmission = (sandboxTask, done) ->
		extractPath = $.services.namespaceService.makeFsPath 'testCase', sandboxTask.assignment.asgId
		sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId

		runTestCase = (testCaseName, done) ->
			inPath = path.join extractPath, testCaseName, 'in'
			outPath = path.join extractPath, testCaseName, 'out'
			hintPath = path.join extractPath, testCaseName, 'hint'

			code = sandboxTask.submission.code
			input = fse.createReadStream inPath
			testCaseRunPath = path.join sandboxrunPath, testCaseName
			sandboxConfig = sandboxTask.assignment.sandboxConfig

			$.services.sandboxService.compileRunCompareWithInputCode outPath, code, input, testCaseRunPath, sandboxConfig, (err, result) ->
				return $.utils.onError done, err if err

				# Accepted
				return done null, makeRunResult result, testCaseName if result.ok && result.matchExpected

				# Wrong Answer
				$.services.testCaseService.readHint hintPath, (err, hint) ->
					return $.utils.onError done, err if err

					result.hint = hint if hint

					done null, makeRunResult result, testCaseName

		runRunTestCase = (testCaseName, done) ->
			$.emitter.emit 'resultRunning', sandboxTask.submission.subId, testCaseName
			runTestCase testCaseName, (err, runResult) ->
				runResult = {testCaseName: testCaseName, status: 'error', message: 'Server Error', errorMessage: err.message} if err
				$.emitter.emit 'resultEvaluated', sandboxTask.submission.subId, testCaseName, runResult
				done null, runResult

		$.emitter.emit 'submissionRunning', sandboxTask.submission.subId
		async.series [
			_.partial $.services.testCaseService.extractTestCaseCached, sandboxTask.assignment.testCaseFileStorageKey, extractPath
			_.partial async.mapSeries, sandboxTask.assignment.sandboxConfig.testCaseNames, runRunTestCase
		], (err, [__, runResults]) ->
			if err
				runResults = _.map sandboxTask.assignment.sandboxConfig.testCaseNames, (testCaseName) -> {testCaseName: testCaseName, status: 'error', message: 'Server Error', errorMessage: err.message}
				$.emitter.emit 'submissionError', sandboxTask.submission.subId, err.message, runResults
			else
				$.emitter.emit 'submissionEvaluated', sandboxTask.submission.subId, runResults
			done null, runResults

	processRun = (sandboxTask, done) ->
		code = sandboxTask.submission.code
		input = sandboxTask.submission.input
		sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId
		sandboxConfig = sandboxTask.assignment.sandboxConfig

		output = sandboxTask.submission.output
		outPath = path.join sandboxrunPath, 'out'
		testCaseRunPath = path.join sandboxrunPath, 'run'

		async.series [
			_.partial fse.outputFile, outPath, output
			_.partial $.services.sandboxService.compileRunCompareOutputWithInputCode, outPath, code, input, testCaseRunPath, sandboxConfig
		], (err, [__, result]) ->
			result = {status: 'error', message: 'Server Error', errorMessage: err.message} if err

			result.input = sandboxTask.submission.input
			result.expectedOutput = sandboxTask.submission.output

			done null, makeRunResult result, 'run'

	processEval = (sandboxTask, done) ->
		code = sandboxTask.submission.code
		input = sandboxTask.submission.input
		sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId
		sandboxConfig = sandboxTask.assignment.sandboxConfig

		$.services.sandboxService.compileRunOutputWithInputCode code, input, sandboxrunPath, sandboxConfig, (err, result) ->
			result = {status: 'error', message: 'Server Error', errorMessage: err.message} if err

			result.input = sandboxTask.submission.input

			done null, makeRunResult result, 'run'

	dispatch = (sandboxTask, done) ->
		return processSubmission sandboxTask, done if !sandboxTask.submission.type

		switch sandboxTask.submission.type
			when 'run'
				processRun sandboxTask, done
			when 'eval'
				processEval sandboxTask, done

	self.worker = (submission, done) ->
		sandboxTask =
			submission: submission

		$.services.assignmentService.findByAsgId sandboxTask.submission.asgId, (err, assignment) ->
			return $.utils.onError done, err if err

			sandboxTask.assignment = assignment

			dispatch sandboxTask, done

	return self
