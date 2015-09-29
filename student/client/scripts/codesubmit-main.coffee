app = angular.module 'codesubmit-student', ['ngRoute', 'ngCookies']

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
	.when('/assignments', {
		controller: 'AssignmentsController',
		templateUrl: 'views/assignments'
	})
	.when('/submissions/:id?', {
		controller: 'SubmissionsController',
		templateUrl: 'views/submissions'
	})
	.otherwise({
		redirectTo: '/'
	})

	return

app.run ($rootScope, $location, userService, messageService, redirectService) ->
	$rootScope.$on '$routeChangeSuccess', () ->
		redirectService.redirectToHome() if !userService.getUser(true)
		messageService.clear()
