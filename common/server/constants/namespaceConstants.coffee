
# Caveat: to avoid potential case sensitivity problem in fs, use lowercase for namespace prefix if possible.
module.exports = ($) ->
	self = {}

	self.fsNamespace =
		sandboxRun: '/codesubmit/worker/sandboxrun'
		testCase: '/codesubmit/worker/testcase'

	self.storageNamespace =
		testCaseFiles: 'assignment/testcasefiles'

	return self
