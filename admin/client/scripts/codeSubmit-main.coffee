app = angular.module 'codesubmit-admin', ['ngRoute', 'ngCookies']

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
	.when('/students', {
		controller: 'StudentsController',
		templateUrl: 'views/students'
	})
	.when('/assignments', {
		controller: 'AssignmentsController',
		templateUrl: 'views/assignments'
	})
	.otherwise({
		redirectTo: '/login'
	})

	return

app.run ($rootScope, $location, userService) ->

	redirectToHome = () ->
		$location.path '/'
		$location.replace()

	$rootScope.logout = () ->
		userService.logout redirectToHome

	user = userService.getUser()

	redirectToHome() if !user || !user.username
