app = angular.module 'codesubmit-admin'

app.service 'redirectService', ($rootScope, $location) ->
	self = {}

	self.redirectToHome = () ->
		$location.path if $rootScope.user then '/students' else '/'
		$location.replace()

	return self
