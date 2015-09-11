app = angular.module 'codeSubmit-admin', ['ngRoute', 'ngCookies']

app.config ($routeProvider) ->

	$routeProvider
	.when('/', {
		controller: 'LoginController',
		templateUrl: 'views/login'
	})
	.when('/login', {
		controller: 'LoginController',
		templateUrl: 'views/login'
	})
	.otherwise({
		redirectTo: '/'
	})

	return
