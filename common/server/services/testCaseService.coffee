childProcess = require 'child_process'

_ = require 'lodash'
fse = require 'fs-extra'
unzip = require 'node-unzip-2'

module.exports = ($) ->
	self = {}

	testCaseCache = {}

	self.extractTestCase = (testCaseFileStorageKey, extractPath, done) ->
		fse.remove extractPath, (err) ->
			return $.utils.onError done, err if err

			$.stores.storageStore.readStream(testCaseFileStorageKey)
				.pipe(unzip.Extract {path: extractPath})
				.on('error', done)
				.on 'close', done

	self.extractTestCaseCached = (testCaseFileStorageKey, extractPath, done) ->
		$.stores.storageStore.findByKey testCaseFileStorageKey, (err, fileInfo) ->
			return done null if testCaseCache[testCaseFileStorageKey] && _.isEqual testCaseCache[testCaseFileStorageKey].uploadDate, fileInfo.uploadDate

			self.extractTestCase testCaseFileStorageKey, extractPath, (err) ->
				return $.utils.onError done, err if err

				testCaseCache[testCaseFileStorageKey] = fileInfo

				done null

	self.isEqualFile = (fileAPath, fileBPath, strictCompare, done) ->
		cmd = [
			'diff'
			if strictCompare then '' else '-bB'
			fileAPath
			fileBPath
		].join ' '

		childProcess.exec cmd, (err, stdout, stderr) ->
			return $.utils.onError done, err if err && err.code != 1
			done null, stdout == ''

	self.readHint = (hintPath, done) ->
		fse.readFile hintPath, 'utf8', (err, hint) ->
			return done null, hint if !err && hint
			done null

	return self
