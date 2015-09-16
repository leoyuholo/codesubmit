app = angular.module 'codesubmit-admin'

app.service 'urlService', ($http) ->
	self = {}

	apiPrefix = '/api'

	self.loginUser = () ->
		return "#{apiPrefix}/user/login"

	self.logoutUser = () ->
		return "#{apiPrefix}/user/logout"

	self.updateAdmin = () ->
		return "#{apiPrefix}/admin/update"

	self.post = (url, payload, done) ->
		$http.post(url, payload).success( (data) ->
			if data.success
				done null, data
			else
				done new Error(data.msg)
		).error (data, status) ->
			done new Error("#{data} status: #{status}")

	self.get = (url, done) ->
		$http.get(url).success( (data) ->
			if data.success
				done null, data
			else
				done new Error(data.msg)
		).error (data, status) ->
			done new Error("#{data} status: #{status}")

	return self
