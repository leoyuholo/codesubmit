childProcess = require 'child_process'
path = require 'path'

_ = require 'lodash'
async = require 'async'
fse = require 'fs-extra'
unzip = require 'node-unzip-2'
Promise = require 'bluebird'

module.exports = ($) ->
	self = {}

	extractSandboxConfig = (sandboxConfigFileStorageKey, extractPath, done) ->
		fse.remove extractPath, (err) ->
			return $.utils.onError done, err if err

			$.stores.storageStore.readStream(sandboxConfigFileStorageKey)
				.pipe(unzip.Extract {path: extractPath})
				.on('error', done)
				.on 'close', () ->
					fse.readFile path.join(extractPath, 'assignment.json'), 'utf8', (err, data) ->
						return $.utils.onError done, err if err

						sandboxConfig = {}

						try
							sandboxConfig = JSON.parse data.replace /^\uFEFF/, ''
						catch err
							return $.utils.onError done, err if err

						done null, sandboxConfig

	prepare = (sandboxTask, done) ->
		sandboxTask.sandboxConfigFileStorageKey = $.services.namespaceService.makeStorageKey 'sandboxConfigFiles', sandboxTask.asgId
		sandboxTask.extractPath = $.services.namespaceService.makeFsPath 'sandboxConfig', sandboxTask.asgId
		sandboxTask.sandboxrunPath = $.services.namespaceService.makeFsPath 'sandboxRun', sandboxTask.subId
		sandboxTask.sandboxoutPath = $.services.namespaceService.makeFsPath 'sandboxOut', sandboxTask.subId

		extractSandboxConfig sandboxTask.sandboxConfigFileStorageKey, sandboxTask.extractPath, (err, sandboxConfig) ->
			return $.utils.onError done, err if err

			sandboxTask.sandboxConfig = sandboxConfig
			sandboxTask.codePath = path.join sandboxTask.sandboxrunPath, sandboxConfig.codeFilename

			fse.outputFile sandboxTask.codePath, sandboxTask.code, (err) ->
				return $.utils.onError done, err if err

				done null, sandboxTask

	makeRunCmd = (sandboxTask) ->
		sandboxConfig = sandboxTask.sandboxConfig
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
			'-m', sandboxConfig.memoryLimitMb
			'-o', sandboxConfig.outputLimitKb
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
			answerStream = fse.createOutputStream answerPath

			sandbox = childProcess.exec cmd, {timeout: 20000}, (err, stdout, stderr) ->
				return reject err if err

				stdouts = stdout.split('\x00')

				answer = stdouts[1]
				resultJSON = {}
				try
					resultJSON = JSON.parse stdouts[2]
				catch err
					return reject err if err

				return resolve {correct: false, message: resultJSON.result} if resultJSON.result[0] != 'OK'

				fse.outputFile answerPath, answer, (err) ->
					return reject err if err

					diffCmd = makeDiffCmd outPath, answerPath, sandboxTask.strictCompare

					childProcess.exec diffCmd, (err, stdout, stderr) ->
						return resolve {correct: true} if !err

						fse.readFile hintPath, 'utf8', (err, data) ->
							console.log 'hint', err, data
							resolve {correct: false, message: data || ''}

			inStream.pipe(sandbox.stdin)
				.on('error', reject)
				.on 'close', () ->
					sandbox.stdin.end()

	runSandbox = (sandboxTask, done) ->

		async.mapSeries sandboxTask.sandboxConfig.testCases, ( (testCase, done) ->
			runTestCasePromise = runTestCase sandboxTask, testCase

			runTestCasePromise.then (_.partial done, null), done
		), (err, results) ->
			return $.utils.onError done, err if err

			sandboxTask.testResults = results

			done null, sandboxTask

	cleanup = (sandboxTask, done) ->
		submission =
			subId: sandboxTask.subId
			status: 'Done'
			evaluateDt: new Date()
			results: sandboxTask.testResults
			score: _.filter(sandboxTask.testResults, 'correct').length
		console.log submission
		$.stores.submissionStore.update submission, done

	processSubmission = (sandboxTask, done) ->
		async.waterfall [
			_.partial prepare, sandboxTask
			runSandbox
			cleanup
		], done

	self.work = (sandboxTask, done) ->
		async.series [
			_.partial $.services.statusService.startJob, sandboxTask
			_.partial processSubmission, sandboxTask
			_.partial $.services.statusService.finishJob, sandboxTask
		], done

	return self
