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
	.when('/admins', {
		controller: 'AdminsController',
		templateUrl: 'views/admins'
	})
	.when('/assignments/:id?', {
		controller: 'AssignmentsController',
		templateUrl: 'views/assignments'
	})
	.when('/submissions', {
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
