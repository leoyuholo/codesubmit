app = angular.module 'codesubmit', ['ngRoute', 'ngCookies', 'ngSanitize', 'ui.bootstrap', 'ui.ace', 'hc.marked']

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
	.when('/assignments', {
		controller: 'assignmentsController',
		templateUrl: 'views/assignments'
	})
	.when('/assignment/:asgid/:asgname?', {
		controller: 'assignmentController',
		templateUrl: 'views/assignment'
	})
	.when('/submissions/:asgid/:asgname', {
		controller: 'submissionsController',
		templateUrl: 'views/submissions'
	})
	.when('/submission/:asgid/:asgname/:subid/:subname', {
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
	$rootScope.homePath = '/assignments'

	$rootScope.$on '$routeChangeSuccess', () ->
		redirectService.redirectToHome() if !userService.getUser(true)
		messageService.clear()
