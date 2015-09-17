app = angular.module 'codesubmit-admin'

app.service 'userService', ($rootScope, urlService) ->
	self = {}

	self.setUser = (user) ->
		localStorage.setItem 'user', JSON.stringify user
		$rootScope.user = user

	self.getUser = (forceReload) ->
		if forceReload || !$rootScope.user
			$rootScope.user = JSON.parse localStorage.getItem 'user'

		return $rootScope.user

	self.clearUser = () ->
		localStorage.removeItem 'user'
		delete $rootScope.user

	self.login = (email, password, done) ->
		payload =
			email: email
			password: password

		urlService.post urlService.loginUser(), payload, (err, data) ->
			return done err if err

			self.setUser data.user
			done null, data

	self.logout = (done) ->
		urlService.get urlService.logoutUser(), (err, data) ->
			return done err if err

			self.clearUser()
			done null

	return self
