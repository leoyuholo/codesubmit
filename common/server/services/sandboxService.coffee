childProcess = require 'child_process'
path = require 'path'

_ = require 'lodash'
async = require 'async'
fse = require 'fs-extra'
Promise = require('q').Promise

module.exports = ($) ->
	self = {}

	makeCompileCmd = (sandboxrunPath, sandboxConfig) ->
		[
			'docker'
			'run'
			'--rm'
			'--net', 'none'
			'--security-opt', 'apparmor:unconfined'
			'--entrypoint', 'sh'
			'-v', sandboxrunPath + ':/vol/'
			'tomlau10/sandbox-run'
			'-c', "'#{sandboxConfig.compileCommand}'"
		].join ' '

	makeRunCmd = (sandboxrunPath, sandboxConfig) ->
		[
			'docker'
			'run'
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

	makeCompileRunCmd = (sandboxrunPath, sandboxConfig) ->
		[
			'docker'
			'run'
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
			'-c', sandboxConfig.codeFilename
			'-OEC'
			sandboxConfig.executableFilename
		].join ' '

	self.compile = (cmd, sandboxrunPath, sandboxConfig, done) ->
		childProcess.exec makeCompileCmd(sandboxrunPath, sandboxConfig), {timeout: sandboxConfig.commandTimeoutMs}, (err, stdout, stderr) ->
			if stderr
				error = new Error('Compile Error')
				error.compileErrorMessage = stderr
				return done error

			return $.utils.onError done, err if err
			done null

	self.run = (sandboxrunPath, sandboxConfig, done) ->
		return childProcess.exec makeRunCmd(sandboxrunPath, sandboxConfig), {timeout: sandboxConfig.commandTimeoutMs}, (err, stdout, stderr) ->
			return $.utils.onError done, err if err
			done null, JSON.parse stdout

	self.runWithInput = (input, sandboxrunPath, sandboxConfig, done) ->
		sandbox = self.run sandboxrunPath, sandboxConfig, done

		if _.isString input
			sandbox.stdin.write input, () -> sandbox.stdin.end()
		else
			input.pipe(sandbox.stdin)
				.on('error', (err) -> return $.utils.onError _.noop, err if err)
				.on 'close', () -> sandbox.stdin.end()

	self.compileRun = (code, sandboxrunPath, sandboxConfig) ->
		return childProcess.exec makeCompileRunCmd(sandboxrunPath, sandboxConfig), {timeout: sandboxConfig.commandTimeoutMs}, (err, stdout, stderr) ->
			return $.utils.onError done, err if err
			fse.readJSON path.join sandboxrunPath, 'result.json', done

	return self
