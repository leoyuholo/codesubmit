app = angular.module 'codesubmit', ['ngRoute', 'ngCookies', 'ui.bootstrap', 'ui.ace']

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
	.when('/assignments/:asgid?', {
		controller: 'AssignmentsController',
		templateUrl: 'views/assignments'
	})
	.when('/submissions/:asgid?', {
		controller: 'SubmissionsController',
		templateUrl: 'views/submissions'
	})
	.otherwise({
		redirectTo: '/'
	})

	return

app.run ($rootScope, $location, userService, messageService, redirectService) ->
	$rootScope.homePath = '/students'

	$rootScope.$on '$routeChangeSuccess', () ->
		redirectService.redirectToHome() if !userService.getUser(true)
		messageService.clear()