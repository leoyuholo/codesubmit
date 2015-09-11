app = angular.module 'codeSubmit-admin'

app.service 'userService', ($http, $rootScope, urlService) ->
	self = {}

	self.setUser = (user) ->
		localStorage.setItem 'user', user
		$rootScope.user = user

	self.getUser = () ->
		return $rootScope.user if $rootScope.user

		user = localStorage.getItem 'user'
		$rootScope.user = user if user

		return user

	self.clearUser = () ->
		localStorage.removeItem 'user'
		$rootScope.user = {}

	self.login = (email, password, done) ->
		payload =
			email: email
			password: password

		$http.post(urlService.login(), payload).success( (data) ->
			if data.success
				self.setUser data.user
				done null, data
			else
				done new Error(data.msg)
		).error (data, status) ->
			done new Error("#{data} status: #{status}")

	self.logout = (done) ->
		$http.get(urlService.logout()).success( (data) ->
			if data.success
				userService.clearUser()
				done null
			else
				done new Error(data.msg)
		).error (data, status) ->
			done new Error("#{data} status: #{status}")

	return self
