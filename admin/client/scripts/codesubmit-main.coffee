app = angular.module 'codesubmit', ['ngRoute', 'ngCookies', 'ngSanitize', 'ui.bootstrap', 'ui.ace', 'hc.marked']

app.config ($routeProvider, markedProvider) ->
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
	.when('/submission/:subid?', {
		controller: 'SubmissionController',
		templateUrl: 'views/submission'
	})
	.otherwise({
		redirectTo: '/'
	})

	markedProvider.setOptions
		sanitize: true
		gfm: true
		tables: true

	return

app.run ($rootScope, $location, userService, messageService, redirectService) ->
	$rootScope.homePath = '/students'

	$rootScope.$on '$routeChangeSuccess', () ->
		redirectService.redirectToHome() if !userService.getUser(true)
		messageService.clear()