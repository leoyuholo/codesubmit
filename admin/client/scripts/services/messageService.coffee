app = angular.module 'codesubmit-admin'

app.service 'messageService', ($rootScope) ->
	self = {}

	self.clear = () ->
		$rootScope.successMessage = ''
		$rootScope.errorMessage = ''

	self.error = (errorMessage) ->
		console.log 'error', errorMessage
		self.clear()
		$rootScope.errorMessage = errorMessage

	self.success = (successMessage) ->
		console.log 'success', successMessage
		self.clear()
		$rootScope.successMessage = successMessage

	return self
