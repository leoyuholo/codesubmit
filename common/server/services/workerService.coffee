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

	extractTestCase = (sandboxTask, done) ->
		fse.remove sandboxTask.extractPath, (err) ->
			return $.utils.onError done, err if err

			$.stores.storageStore.readStream(sandboxTask.assignment.testCaseFileStorageKey)
				.pipe(unzip.Extract {path: sandboxTask.extractPath})
				.on('error', done)
				.on 'close', done

	extractTestCaseCached = (sandboxTask, done) ->
		key = sandboxTask.assignment.testCaseFileStorageKey

		$.stores.storageStore.findByKey key, (err, fileInfo) ->
			if testCaseCache[key] && _.isEqual testCaseCache[key].uploadDate, fileInfo.uploadDate
				return done null

			extractTestCase sandboxTask, (err) ->
				return $.utils.onError done, err if err

				testCaseCache[key] = fileInfo

				done null

	prepare = (sandboxTask, done) ->
		sandboxTask.extractPath = $.services.namespaceService.makeFsPath 'testCase', sandboxTask.submission.asgId
		sandboxTask.sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.submission.subId
		sandboxTask.sandboxoutPath = $.services.namespaceService.makeFsPath 'sandboxOut', sandboxTask.submission.subId

		$.services.assignmentService.findByAsgId sandboxTask.submission.asgId, (err, assignment) ->
			sandboxTask.assignment = assignment
			sandboxTask.codePath = path.join sandboxTask.sandboxrunPath, assignment.sandboxConfig.codeFilename

			async.parallel [
				_.partial fse.outputFile, sandboxTask.codePath, sandboxTask.submission.code
				_.partial extractTestCaseCached, sandboxTask
			], done

	makeRunCmd = (sandboxTask) ->
		sandboxConfig = sandboxTask.assignment.sandboxConfig
		[
			'docker'
			'run'
			'-i'
			'--rm'
			'--net', 'none'
			'--security-opt apparmor:unconfined'
			'-v', sandboxTask.sandboxrunPath + ':/vol/'
			'-u $(id -u):$(id -g)'
			'tomlau10/sandbox-run'
			'-e', sandboxConfig.errorToleranceLevel
			'-n', 1
			'-t', sandboxConfig.timeLimitS
			'-m', sandboxConfig.memoryLimitMB
			'-o', sandboxConfig.outputLimitKB
			'-c', sandboxConfig.codeFilename
			sandboxConfig.executableFilename
		].join ' '

	makeDiffCmd = (outPath, answerPath, strictCompare) ->
		[
			'diff'
			if strictCompare then '' else '-bB'
			outPath
			answerPath
		].join ' '

	runTestCase = (sandboxTask, testCaseName) ->
		return new Promise (resolve, reject) ->
			inPath = path.join sandboxTask.extractPath, testCaseName, 'in'
			outPath = path.join sandboxTask.extractPath, testCaseName, 'out'
			hintPath = path.join sandboxTask.extractPath, testCaseName, 'hint'
			answerPath = path.join sandboxTask.sandboxoutPath, testCaseName, 'out'
			cmd = makeRunCmd sandboxTask

			inStream = fse.createReadStream inPath

			sandbox = childProcess.exec cmd, {timeout: sandboxTask.assignment.sandboxConfig.commandTimeout}, (err, stdout, stderr) ->
				return reject err if err

				stdouts = stdout.split('\x00')

				answer = stdouts[1]
				resultJSON = {}
				try
					resultJSON = JSON.parse stdouts[2]
				catch err
					return reject err if err

				return resolve {testCaseName: testCaseName, correct: false, message: resultJSON.result[0]} if resultJSON.result[0] != 'OK'

				fse.outputFile answerPath, answer, (err) ->
					return reject err if err

					diffCmd = makeDiffCmd outPath, answerPath, sandboxTask.assignment.sandboxConfig.strictCompare

					childProcess.exec diffCmd, (err, stdout, stderr) ->
						return resolve {testCaseName: testCaseName, correct: true, message: 'Accepted', time: resultJSON.execute_time} if !err

						fse.readFile hintPath, 'utf8', (err, data) ->
							resolve {testCaseName: testCaseName, correct: false, message: 'Wrong Answer', time: resultJSON.execute_time, hint: data || ''}

			inStream.pipe(sandbox.stdin)
				.on('error', reject)
				.on 'close', () ->
					sandbox.stdin.end()

	runSandbox = (sandboxTask, done) ->
		async.mapSeries sandboxTask.assignment.sandboxConfig.testCaseNames, ( (testCaseName, done) ->
			runTestCase(sandboxTask, testCaseName).then (_.partial done, null), done
		), (err, results) ->
			return $.utils.onError done, err if err

			sandboxTask.testResults = results

			done null

	cleanup = (sandboxTask, done) ->
		submission =
			subId: sandboxTask.submission.subId
			status: 'evaluated'
			evaluateDt: new Date()
			results: sandboxTask.testResults
			score: _.filter(sandboxTask.testResults, 'correct').length

		$.stores.submissionStore.update submission, done

	processSubmission = (sandboxTask, done) ->
		async.series [
			_.partial prepare, sandboxTask
			_.partial runSandbox, sandboxTask
			_.partial cleanup, sandboxTask
		], done

	self.work = (submission, done) ->
		sandboxTask =
			submission: submission

		async.series [
			_.partial $.services.statusService.startJob, sandboxTask
			_.partial processSubmission, sandboxTask
			_.partial $.services.statusService.finishJob, sandboxTask
		], done

	return self
