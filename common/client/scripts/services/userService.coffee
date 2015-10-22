app = angular.module 'codesubmit'

app.service 'userService', ($rootScope, urlService) ->
	self = {}

	setUser = (user) ->
		localStorage.setItem 'user', JSON.stringify user
		$rootScope.user = user

	self.getUser = (forceReload) ->
		if forceReload || !$rootScope.user
			$rootScope.user = JSON.parse localStorage.getItem 'user'

		return $rootScope.user

	clearUser = () ->
		localStorage.removeItem 'user'
		delete $rootScope.user

	self.login = (email, password, done) ->
		payload =
			email: email
			password: password

		urlService.post urlService.user.login(), payload, (err, data) ->
			return done err if err

			setUser data.user
			done null, data

	self.logout = (done) ->
		urlService.get urlService.user.logout(), (err, data) ->
			return done err if err

			clearUser()
			done null

	return self
