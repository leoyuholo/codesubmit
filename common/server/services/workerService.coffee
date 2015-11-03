childProcess = require 'child_process'
path = require 'path'

_ = require 'lodash'
async = require 'async'
fse = require 'fs-extra'
unzip = require 'node-unzip-2'
q = require 'q'
Promise = q.Promise

module.exports = ($) ->
	self = {}

	makeRunResult = (result, testCaseName) ->
		runResult = {}

		runResult.testCaseName = if testCaseName then testCaseName else 'run'
		if result.ok && result.matchExpected != undefined
			runResult.correct = result.matchExpected
			if runResult.correct
				runResult.message = 'Accepted'
			else
				runResult.message = 'Wrong Answer'
		else
			runResult.message = result.message
		runResult.hint = result.hint if !runResult.correct && result.hint
		runResult.compileErrorMessage = result.compileErrorMessage if result.compileErrorMessage
		runResult.memory = result.memory_usage if result.memory_usage
		runResult.time = result.execute_time if result.execute_time
		runResult.input = result.input if result.input
		runResult.output = result.output if result.output
		runResult.expectedOutput = result.expectedOutput if result.expectedOutput
		runResult.status = 'evaluated'

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
				return done null, result if result.ok && result.matchExpected

				# Wrong Answer
				$.services.testCaseService.readHint hintPath, (err, hint) ->
					return $.utils.onError done, err if err

					result.hint = hint if hint

					done null, result

		runRunTestCase = (testCaseName, done) ->
			$.services.submissionService.updateResultRunning sandboxTask.submission.subId, testCaseName, (err) ->
				runTestCase testCaseName, (err, result) ->
					return $.utils.onError done, err if err

					runResult = makeRunResult result, testCaseName

					$.services.submissionService.updateResult sandboxTask.submission.subId, testCaseName, runResult, (err) ->
						return $.utils.onError done, err if err
						done null, runResult

		async.series [
			_.partial $.services.testCaseService.extractTestCaseCached, sandboxTask.assignment.testCaseFileStorageKey, extractPath
			_.partial async.mapSeries, sandboxTask.assignment.sandboxConfig.testCaseNames, runRunTestCase
		], (err, results) ->
			return $.utils.onError done, err if err
			$.services.submissionService.updateEvaluated sandboxTask.submission.subId, results[1], done

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
		], (err, results) ->
			return $.utils.onError done, err if err

			result = results[1]
			result.input = sandboxTask.submission.input
			result.expectedOutput = sandboxTask.submission.output
			runResult = makeRunResult results[1], 'run'

			done null, runResult

	processEval = (sandboxTask, done) ->
		code = sandboxTask.submission.code
		input = sandboxTask.submission.input
		sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId
		sandboxConfig = sandboxTask.assignment.sandboxConfig

		$.services.sandboxService.compileRunOutputWithInputCode code, input, sandboxrunPath, sandboxConfig, (err, result) ->
			return $.utils.onError done, err if err

			result.input = sandboxTask.submission.input
			runResult = makeRunResult result, 'run'

			done null, runResult

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

			dispatch sandboxTask, (err, runResult) ->
				$.logger.log 'error', err if err
				done null, runResult

	return self
