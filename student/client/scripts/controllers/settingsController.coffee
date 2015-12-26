app = angular.module 'codesubmit'

app.controller 'settingsController', ($scope, $location, studentService, messageService) ->

	defaultForm =
		oldPassword: ''
		newPassword: ''
		confirmNewPassword: ''

	$scope.clearChangePasswordForm = () ->
		$scope.changePasswordForm.$setPristine()
		$scope.changePasswordFormData = _.cloneDeep defaultForm

	$scope.submitChangePasswordForm = (oldPassword, newPassword, confirmNewPassword) ->
		return messageService.error 'New password does not match confirm password.' if newPassword != confirmNewPassword

		studentService.changePassword oldPassword, newPassword, (err) ->
			return messageService.error err.message if err

			messageService.success 'Password changed.'

			$scope.clearChangePasswordForm()
