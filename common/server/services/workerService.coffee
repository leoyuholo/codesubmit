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

	testCaseCache = {}

	extractTestCase = (testCaseFileStorageKey, extractPath, done) ->
		fse.remove extractPath, (err) ->
			return $.utils.onError done, err if err

			$.stores.storageStore.readStream(testCaseFileStorageKey)
				.pipe(unzip.Extract {path: extractPath})
				.on('error', done)
				.on 'close', done

	extractTestCaseCached = (testCaseFileStorageKey, extractPath, done) ->
		$.stores.storageStore.findByKey testCaseFileStorageKey, (err, fileInfo) ->
			return done null if testCaseCache[testCaseFileStorageKey] && _.isEqual testCaseCache[testCaseFileStorageKey].uploadDate, fileInfo.uploadDate

			extractTestCase testCaseFileStorageKey, extractPath, (err) ->
				return $.utils.onError done, err if err

				testCaseCache[testCaseFileStorageKey] = fileInfo

				done null

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
			runResult.message = result.errorMessage
		runResult.hint = result.hint if !runResult.correct && result.hint
		runResult.compileErrorMessage = result.compileErrorMessage if result.compileErrorMessage
		runResult.memory = result.memory_usage if result.memory_usage
		runResult.time = result.execute_time if result.execute_time
		runResult.input = result.input if result.input
		runResult.output = result.output if result.output
		runResult.expectedOutput = result.expectedOutput if result.expectedOutput

		return runResult

	compareFiles = (fileAPath, fileBPath, strictCompare, done) ->
		cmd = [
			'diff'
			if strictCompare then '' else '-bB'
			fileAPath
			fileBPath
		].join ' '

		childProcess.exec cmd, (err, stdout, stderr) ->
			return $.utils.onError done, err if err && err.code != 1
			done null, stdout == ''

	run = (input, code, sandboxrunPath, sandboxConfig, done) ->
		async.series [
			_.partial fse.outputFile, path.join(sandboxrunPath, sandboxConfig.codeFilename), code
			_.partial $.services.sandboxService.compile, sandboxConfig.compileCommand, sandboxrunPath, sandboxConfig
			_.partial $.services.sandboxService.runWithInput, input, sandboxrunPath, sandboxConfig
		], (err, results) ->
			return $.utils.onError done, err if err && err.message != 'Compile Error'

			results[2] = {result: ['Compile Error'], compileErrorMessage: err.compileErrorMessage} if err && err.message == 'Compile Error'
			result = results[2]
			result.ok = result.result[0] == 'OK'
			result.errorMessage = result.result[0] if result.result[0] != 'OK'

			done null, result

	runAndCompare = (input, outPath, code, sandboxrunPath, sandboxConfig, done) ->
		run input, code, sandboxrunPath, sandboxConfig, (err, result) ->
			return $.utils.onError done, err if err
			return done null, result if !result.ok

			compareFiles outPath, path.join(sandboxrunPath, 'stdout0'), sandboxConfig.strictCompare, (err, matchExpected) ->
				return $.utils.onError done, err if err

				result.matchExpected = matchExpected

				done null, result

	runTestCase = (sandboxTask, testCaseName, done) ->
		testCaseRunPath = path.join sandboxTask.sandboxrunPath, testCaseName

		inPath = path.join sandboxTask.extractPath, testCaseName, 'in'
		outPath = path.join sandboxTask.extractPath, testCaseName, 'out'
		hintPath = path.join sandboxTask.extractPath, testCaseName, 'hint'

		runAndCompare fse.createReadStream(inPath), outPath, sandboxTask.submission.code, testCaseRunPath, sandboxTask.assignment.sandboxConfig, (err, result) ->
			return $.utils.onError done, err if err

			# Accepted
			return done null, result if result.ok && result.matchExpected

			# Wrong Answer
			fse.readFile hintPath, 'utf8', (err, hint) ->
				result.hint = hint if !err && hint
				done null, result

	processSubmission = (sandboxTask, notify, done) ->
		sandboxTask.sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId
		sandboxTask.extractPath = $.services.namespaceService.makeFsPath 'testCase', sandboxTask.assignment.asgId

		_runTestCase = (testCaseName, done) ->
			runTestCase sandboxTask, testCaseName, (err, result) ->
				return $.utils.onError done, err if err

				runResult = makeRunResult result, testCaseName

				notify runResult

				done null, runResult

		async.series [
			_.partial extractTestCaseCached, sandboxTask.assignment.testCaseFileStorageKey, sandboxTask.extractPath
			_.partial async.mapSeries, sandboxTask.assignment.sandboxConfig.testCaseNames, _runTestCase
		], (err, results) ->
			return $.utils.onError done, err if err

			done null, results[1]

	processRun = (sandboxTask, done) ->
		sandboxTask.sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId

		outPath = path.join sandboxTask.sandboxrunPath, 'out'
		testCaseRunPath = path.join sandboxTask.sandboxrunPath, 'run'

		async.series [
			_.partial fse.outputFile, outPath, sandboxTask.submission.output
			_.partial runAndCompare, sandboxTask.submission.input, outPath, sandboxTask.submission.code, testCaseRunPath, sandboxTask.assignment.sandboxConfig
		], (err, results) ->
			return $.utils.onError done, err if err

			fse.readFile path.join(testCaseRunPath, 'stdout0'), 'utf8', (err, stdout0) ->
				# ignore err

				result = results[1]
				result.input = sandboxTask.submission.input
				result.expectedOutput = sandboxTask.submission.output
				result.output = stdout0 if !err && stdout0
				runResult = makeRunResult results[1], 'run'

				done null, runResult

	processEval = (sandboxTask, done) ->
		sandboxTask.sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId

		run sandboxTask.submission.input, sandboxTask.submission.code, sandboxTask.sandboxrunPath, sandboxTask.assignment.sandboxConfig, (err, result) ->
			return $.utils.onError done, err if err

			fse.readFile path.join(sandboxTask.sandboxrunPath, 'stdout0'), 'utf8', (err, stdout0) ->
				# ignore err

				result.input = sandboxTask.submission.input
				result.output = if !err && stdout0 != undefined then stdout0 else ''
				runResult = makeRunResult result, 'run'

				done null, runResult

	self.work = (submission, notify, done) ->
		sandboxTask =
			submission: submission

		$.services.assignmentService.findByAsgId sandboxTask.submission.asgId, (err, assignment) ->
			return $.utils.onError done, err if err

			sandboxTask.assignment = assignment

			if sandboxTask.submission.type
				switch sandboxTask.submission.type
					when 'run'
						processRun sandboxTask, done
					when 'eval'
						processEval sandboxTask, done
			else
				processSubmission sandboxTask, notify, (err, evaluateResults) ->
					return $.utils.onError done, err if err

					$.services.submissionService.updateWithEvaluateResult sandboxTask.submission, evaluateResults, done

	return self
