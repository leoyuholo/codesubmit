app = angular.module 'codesubmit-admin', ['ngRoute', 'ngCookies']

app.config ($routeProvider) ->
	$routeProvider
	.when('/', {
		controller: 'LoginController',
		templateUrl: 'views/login'
	})
	.when('/settings', {
		controller: 'SettingsController',
		templateUrl: 'views/settings'
	})
	.when('/students', {
		controller: 'StudentsController',
		templateUrl: 'views/students'
	})
	.when('/assignments', {
		controller: 'AssignmentsController',
		templateUrl: 'views/assignments'
	})
	.otherwise({
		redirectTo: '/'
	})

	return

app.run ($rootScope, $location, userService, messageService, redirectService) ->
	$rootScope.$on '$routeChangeSuccess', () ->
		redirectService.redirectToHome() if !userService.getUser(true)
		messageService.clear()
