app = angular.module 'codesubmit-admin'

app.controller 'AdminsController', ($scope, adminService, messageService) ->

	defaultAdmin =
		username: ''
		email: ''
		remarks: ''

	$scope.admins = []
	$scope.adminListMsg = {}
	$scope.newAdmins = []
	$scope.adminCreateMsg = {}

	$scope.listAdmins = () ->
		$scope.adminListMsg.refreshing = true
		adminService.listAdmins (err, data) ->
			$scope.adminListMsg.refreshing = false
			return messageService.error $scope.adminListMsg, err.message if err

			$scope.admins = data.admins

	$scope.deactivate = (admin) ->
		console.log "deactivate"
		return

	$scope.resetPassword = (admin) ->
		console.log "resetPassword"
		return

	$scope.createAdmin = (admin) ->
		admin.status = 'Adding'
		adminService.createAdmin admin, (err) ->
			if err
				delete admin.status
				return messageService.error $scope.adminCreateMsg, err.message

			messageService.success $scope.adminCreateMsg, 'Admin added.'
			admin.status = 'Added'

	$scope.addEmptyAdmin = () ->
		$scope.newAdmins.push _.cloneDeep defaultAdmin

	$scope.listAdmins()
	$scope.addEmptyAdmin()
