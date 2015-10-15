
# Caveat: to avoid potential case sensitivity problem in fs, use lowercase for namespace prefix if possible.
module.exports = ($) ->
	self = {}

	self.fsNamespace =
		'sandboxRun': '/codesubmit/worker/sandboxrun'
		'sandboxConfig': '/codesubmit/worker/sandboxconfig'
		'sandboxOut': '/codesubmit/worker/sandboxout'

	self.storageNamespace =
		'sandboxConfigFiles': 'assignment/sanndboxconfigfiles'

	return self
