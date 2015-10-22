app = angular.module 'codesubmit'

app.service 'redirectService', ($rootScope, $location) ->
	self = {}

	self.redirectToHome = () ->
		$location.path if $rootScope.user then $rootScope.homePath else '/'
		$location.replace()

	self.redirectTo = (key, id) ->
		console.log('/' + Array.prototype.join.call arguments, '/')
		$location.path '/' + Array.prototype.join.call arguments, '/'
		$location.replace()

	return self
