app = angular.module 'codesubmit'

app.controller 'loginController' ,($scope, userService, messageService, redirectService) ->

	$scope.submitLogin = (email, password) ->
		messageService.clear()

		userService.login email, password, (err, user) ->
			return messageService.error err.message if err
			return messageService.error 'Server response no users' if !user

			redirectService.redirectToHome()

	redirectService.redirectToHome() if userService.getUser()
