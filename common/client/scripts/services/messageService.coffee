app = angular.module 'codesubmit'

app.service 'messageService', ($rootScope, userService) ->
	self = {}

	self.clear = (target) ->
		target = target || $rootScope
		target.successMessage = ''
		target.errorMessage = ''

	self.error = (target, errorMessage) ->
		if _.isString target
			errorMessage = target
			target = $rootScope

		console.log 'error', errorMessage
		userService.logout() if errorMessage == 'Unauthorized access.'

		self.clear target
		target.errorMessage = errorMessage

	self.success = (target, successMessage) ->
		if _.isString target
			successMessage = target
			target = $rootScope

		console.log 'success', successMessage

		self.clear target
		target.successMessage = successMessage

	return self
