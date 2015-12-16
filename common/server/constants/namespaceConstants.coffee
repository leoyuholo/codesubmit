path = require 'path'

# Caveat: to avoid potential case sensitivity problem in fs, use lowercase for namespace prefix if possible.
module.exports = ($) ->
	self = {}

	self.fsNamespace =
		sandboxRun: path.join $.config.fsNamespaceRoot, 'worker', 'sandboxrun'
		testCase: path.join $.config.fsNamespaceRoot, 'worker', 'testcase'

	self.storageNamespace =
		testCaseFiles: 'assignment/testcasefiles'

	return self
