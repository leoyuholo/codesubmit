app = angular.module 'codesubmit-student'

app.service 'urlService', ($http) ->

	apiPrefix = '/api'

	self =
		user:
			login: () -> "#{apiPrefix}/user/login"
			logout: () -> "#{apiPrefix}/user/logout"
		student:
			changePassword: () -> "#{apiPrefix}/student/changepassword"
		assignment:
			list: () -> "#{apiPrefix}/assignment/list"
			findByAsgId: (asgId) -> "#{apiPrefix}/assignment/findbyasgid/#{asgId}"
		submission:
			list: (asgId) -> "#{apiPrefix}/submission/list/#{asgId}"
			submit: (asgId) -> "#{apiPrefix}/submission/submit/#{asgId}"

	self.post = (url, payload, options, done) ->
		if _.isFunction options
			done = options
			options = null

		$http.post(url, payload, options).then ( (res) ->
			if res.data.success
				done null, res.data
			else
				done new Error(res.data.msg)
		), (res) ->
			done new Error("#{res.data} status: #{res.status}")

	self.get = (url, done) ->
		$http.get(url).then ( (res) ->
			if res.data.success
				done null, res.data
			else
				done new Error(res.data.msg)
		), (res) ->
			done new Error("#{res.data} status: #{res.status}")

	return self
