app = angular.module 'codesubmit-admin'

app.controller 'SettingsController', ($scope, $location, adminService, messageService) ->

	defaultForm =
		oldPassword: ''
		newPassword: ''
		confirmNewPassword: ''

	$scope.clearChangePasswordForm = () ->
		$scope.changePasswordForm.$setPristine()
		$scope.changePasswordFormData = _.cloneDeep defaultForm

	$scope.submitChangePasswordForm = (oldPassword, newPassword, confirmNewPassword) ->
		return messageService.error 'New password does not match confirm password.' if newPassword != confirmNewPassword

		adminService.update oldPassword, newPassword, (err) ->
			return messageService.error err.message if err

			messageService.success 'Password changed.'

			$scope.clearChangePasswordForm()
