app = angular.module 'codesubmit', ['ngRoute', 'ngCookies']

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
	.when('/assignment/:asgid/:asgname?', {
		controller: 'AssignmentController',
		templateUrl: 'views/assignment'
	})
	.when('/submissions/:asgid/:asgname', {
		controller: 'SubmissionsController',
		templateUrl: 'views/submissions'
	})
	.when('/submission/:asgid/:asgname/:subid/:subname', {
		controller: 'SubmissionController',
		templateUrl: 'views/submission'
	})
	.otherwise({
		redirectTo: '/'
	})

	return

app.run ($rootScope, $location, userService, messageService, redirectService) ->
	$rootScope.homePath = '/assignments'

	$rootScope.$on '$routeChangeSuccess', () ->
		redirectService.redirectToHome() if !userService.getUser(true)
		messageService.clear()
