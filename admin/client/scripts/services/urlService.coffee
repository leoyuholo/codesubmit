app = angular.module 'codesubmit-admin'

app.service 'urlService', () ->

	self = {}

	apiPrefix = '/api'

	self.login = () ->
		return "#{apiPrefix}/user/login"

	self.logout = () ->
		return "#{apiPrefix}/user/logout"

	return self
