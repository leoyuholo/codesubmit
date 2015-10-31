app = angular.module 'codesubmit'

app.service 'redirectService', ($rootScope, $location) ->
	self = {}

	self.redirectToHome = () ->
		$location.path if $rootScope.user then $rootScope.homePath else '/'
		$location.replace()

	self.redirectTo = () ->
		$location.path '/' + Array.prototype.join.call arguments, '/'
		$location.replace()

	return self
