app = angular.module 'codesubmit-student'

app.service 'redirectService', ($rootScope, $location) ->
	self = {}

	self.redirectToHome = () ->
		$location.path if $rootScope.user then '/assignments' else '/'
		$location.replace()

	return self
