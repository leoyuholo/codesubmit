app = angular.module 'codeSubmit-admin', ['ngRoute', 'ngCookies']

app.config ($routeProvider) ->

	$routeProvider
	.when('/login', {
		controller: 'LoginController',
		templateUrl: 'views/login'
	})
	.when('/settings', {
		controller: 'SettingsController',
		templateUrl: 'views/settings'
	})
	.otherwise({
		redirectTo: '/login'
	})

	return
