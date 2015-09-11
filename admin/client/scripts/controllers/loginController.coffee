app = angular.module 'codeSubmit-admin'

app.controller('LoginController', ($scope) ->

	$scope.submitLogin = (email, password) ->
		console.log('email', email)
		console.log('password', password)
)
