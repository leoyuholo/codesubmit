app = angular.module 'codesubmit', ['ngRoute', 'ngCookies', 'ngSanitize', 'ui.bootstrap', 'ui.ace', 'hc.marked', 'smart-table']

app.config ($routeProvider, markedProvider) ->
	$routeProvider
	.when('/', {
		controller: 'loginController',
		templateUrl: 'views/login'
	})
	.when('/settings', {
		controller: 'settingsController',
		templateUrl: 'views/settings'
	})
	.when('/students', {
		controller: 'studentsController',
		templateUrl: 'views/students'
	})
	.when('/admins', {
		controller: 'adminsController',
		templateUrl: 'views/admins'
	})
	.when('/assignments/:asgid?', {
		controller: 'assignmentsController',
		templateUrl: 'views/assignments'
	})
	.when('/submissions/:asgid?', {
		controller: 'submissionsController',
		templateUrl: 'views/submissions'
	})
	.when('/submission/:subid?', {
		controller: 'submissionController',
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