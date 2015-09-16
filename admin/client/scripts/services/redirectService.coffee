app = angular.module 'codesubmit-admin'

app.service 'redirectService', ($rootScope, $location) ->
	self = {}

	self.redirectToHome = () ->
		$location.path if $rootScope.user then '/settings' else '/'
		$location.replace()

	return self
