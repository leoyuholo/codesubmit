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

	self.hashPw = (password) ->
		shaObj = new jsSHA('SHA-512', 'TEXT')
		# TODO: make life harder
		# shaObj.update password + $rootScope.user.email + window.location.hostname
		shaObj.update password + $rootScope.user.email
		shaObj.getHash 'HEX'

	self.login = (email, password, done) ->

		password = self.hashPw email, password

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

	self.testPassword = (password) ->
		return 'Password too short.' if password.length < 8
		return 'Only a-zA-Z0-9!()-._`~@ allowed.' if !/^[a-zA-Z0-9!()-._`~@]+$/.test password
		''

	return self
