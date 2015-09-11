app = angular.module 'codeSubmit-admin'

app.service('urlService', () ->

	self = {}

	apiPrefix = '/api'

	self.login = () ->
		return "#{apiPrefix}/user/login"

	return self
)