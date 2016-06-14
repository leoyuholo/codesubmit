childProcess = require 'child_process'
path = require 'path'

_ = require 'lodash'
fse = require 'fs-extra'
Promise = require('q').Promise

module.exports = ($) ->
	self = {}

	makeCompileCmd = (sandboxrunPath, sandboxConfig, containerName) ->
		[
			'docker'
			'run'
			'--name', containerName
			'--rm'
			'--net', 'none'
			'--security-opt', 'apparmor:unconfined'
			'--entrypoint', 'sh'
			'-v', sandboxrunPath + ':/vol/'
			'-u', '$(id -u):$(id -g)'
			'tomlau10/sandbox-run'
			'-c', "'#{sandboxConfig.compileCommand}'"
		].join ' '

	makeRunCmd = (sandboxrunPath, sandboxConfig, containerName) ->
		[
			'docker'
			'run'
			'--name', containerName
			'-i'
			'--rm'
			'--net', 'none'
			'--security-opt', 'apparmor:unconfined'
			'-v', sandboxrunPath + ':/vol/'
			'-u', '$(id -u):$(id -g)'
			'tomlau10/sandbox-run'
			'-e', sandboxConfig.errorToleranceLevel
			'-n', 1
			'-t', sandboxConfig.timeLimitS
			'-m', sandboxConfig.memoryLimitMB
			'-o', sandboxConfig.outputLimitKB
			'-OEC'
			sandboxConfig.executableFilename
		].join ' '

	makeRmCmd = (containerName) ->
		[
			'docker'
			'rm'
			'-f'
			containerName
		].join ' '

	self.runSandbox = (cmd, opt, containerName, done) ->
		childProcess.exec cmd, opt, (err, stdout, stderr) ->
			childProcess.exec makeRmCmd(containerName), (err, stdout, stderr) ->
				$.utils.onError _.noop, err if err && !/No such container/.test err.message

			done err, stdout, stderr

	self.compile = (sandboxrunPath, sandboxConfig, done) ->
		containerName = $.utils.rng.generateId()

		self.runSandbox makeCompileCmd(sandboxrunPath, sandboxConfig, containerName), {timeout: sandboxConfig.commandTimeoutMs}, containerName, (err, stdout, stderr) ->
			if stderr
				error = new Error('Compile Error')
				error.compileErrorMessage = stderr
				return done error

			return $.utils.onError done, err if err
			done null

	self.run = (sandboxrunPath, sandboxConfig, done) ->
		containerName = $.utils.rng.generateId()

		return self.runSandbox makeRunCmd(sandboxrunPath, sandboxConfig, containerName), {timeout: sandboxConfig.commandTimeoutMs}, containerName, (err, stdout, stderr) ->
			return $.utils.onError done, err if err

			try
				result = JSON.parse "#{stdout}"
			catch err
				debugInfo =
					errorMessage: err.message
					stdout: stdout
					stderr: stderr
				return $.utils.onError done, _.set new Error('Sandbox error.'), 'debugInfo', debugInfo

			result.message = result.result[0]
			result.ok = result.message == 'OK'

			done null, result

	self.runWithInput = (input, sandboxrunPath, sandboxConfig, done) ->
		runWithInputPromise = new Promise( (resolve, reject) ->
			sandbox = self.run sandboxrunPath, sandboxConfig, (err, result) ->
				return reject err if err
				resolve result

			if _.isObject input
				input = fse.createReadStream input.filePath
				input.on('error', reject)
					.pipe(sandbox.stdin)
					.on('error', reject)
					.on 'close', () -> sandbox.stdin.end()
			else if _.isString input
				sandbox.stdin.write input, () -> sandbox.stdin.end()
			else
				sandbox.stdin.end()
		)

		runWithInputPromise.then _.partial(done, null), done

	self.compileRunWithInput = (input, sandboxrunPath, sandboxConfig, done) ->
		self.compile sandboxrunPath, sandboxConfig, (err) ->
			return done null, {message: 'Compile Error', ok: false, compileErrorMessage: err.compileErrorMessage} if err && err.message == 'Compile Error'
			return $.utils.onError done, err if err
			self.runWithInput input, sandboxrunPath, sandboxConfig, done

	self.compileRunWithInputCode = (code, input, sandboxrunPath, sandboxConfig, done) ->
		fse.outputFile path.join(sandboxrunPath, sandboxConfig.codeFilename), code, (err) ->
			return $.utils.onError done, err if err
			self.compileRunWithInput input, sandboxrunPath, sandboxConfig, done

	self.compileRunCompareWithInputCode = (compareToPath, code, input, sandboxrunPath, sandboxConfig, done) ->
		self.compileRunWithInputCode code, input, sandboxrunPath, sandboxConfig, (err, result) ->
			return $.utils.onError done, err if err
			return done null, result if !result.ok

			$.services.testCaseService.isEqualFile compareToPath, path.join(sandboxrunPath, 'stdout0'), sandboxConfig.strictCompare, (err, matchExpected) ->
				return $.utils.onError done, err if err

				result.matchExpected = matchExpected

				done null, result

	self.readOutput = (sandboxrunPath, done) ->
		fse.readFile path.join(sandboxrunPath, 'stdout0'), 'utf8', done

	self.compileRunOutputWithInputCode = (code, input, sandboxrunPath, sandboxConfig, done) ->
		self.compileRunWithInputCode code, input, sandboxrunPath, sandboxConfig, (err, result) ->
			return $.utils.onError done, err if err

			self.readOutput sandboxrunPath, (err, data) ->
				# ignore err

				result.output = if !err && data != undefined then data else ''

				done null, result

	self.compileRunCompareOutputWithInputCode = (compareToPath, code, input, sandboxrunPath, sandboxConfig, done) ->
		self.compileRunCompareWithInputCode compareToPath, code, input, sandboxrunPath, sandboxConfig, (err, result) ->
			return $.utils.onError done, err if err

			self.readOutput sandboxrunPath, (err, data) ->
				# ignore err

				result.output = if !err && data != undefined then data else ''

				done null, result

	return self
