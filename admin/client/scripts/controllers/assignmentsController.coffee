app = angular.module 'codesubmit'

app.controller 'AssignmentsController', ($scope, $routeParams, assignmentService, messageService, redirectService, storageService, urlService) ->

	newDate = new Date()
	newDate.setMilliseconds 0
	newDate.setSeconds 0

	defaultAssignment =
		name: ''
		startDt: newDate
		dueDt: newDate
		hardDueDt: newDate
		submissionLimit: 100
		penalty: 0

	$scope.listAssignments = () ->
		assignmentService.list (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			$scope.assignments = data.assignments

	$scope.findAssignment = (asgId) ->
		assignmentService.findByAsgId asgId, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err

			$scope.assignment = data.assignment

			$scope.getSandboxConfigFileDetails $scope.assignment.sandboxConfigFileStorageKey

	$scope.createAssignment = (assignment) ->
		assignmentService.create assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment created.'

			redirectService.redirectTo 'assignments', data.assignment.asgId

	$scope.updateAssignment = (assignment) ->
		assignmentService.update assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment updated.'

	$scope.getSandboxConfigFileDetails = (key) ->
		$scope.sandboxConfigFileDetails = null

		storageService.findByKey key, (err, data) ->
			return if err && 'File not found.' == err.message
			return messageService.error $scope.sandboxConfigMsg, err.message if err

			$scope.sandboxConfigFileDetails = data.info
			$scope.sandboxConfigFileDetails.filename = $scope.assignment.name + '.zip'
			$scope.sandboxConfigFileDetails.downloadUrl = urlService.storage.get key, $scope.sandboxConfigFileDetails.filename

	$scope.uploadSandboxConfigFile = () ->
		sandboxConfigFile = document.getElementById('sandboxConfig-input').files?[0]

		return messageService.error $scope.sandboxConfigMsg, 'No file chosen.' if !sandboxConfigFile
		return messageService.error $scope.sandboxConfigMsg, "Sandbox config [#{sandboxConfigFile.type || 'no type'}] file type is not supported" if -1 == sandboxConfigFile.type?.indexOf?('zip')

		storageService.post $scope.assignment.sandboxConfigFileStorageKey, sandboxConfigFile, (err) ->
			return messageService.error $scope.sandboxConfigMsg, err.message if err
			messageService.success $scope.sandboxConfigMsg, 'Sandbox config uploaded.'

			$scope.getSandboxConfigFileDetails $scope.assignment.sandboxConfigFileStorageKey

	$scope.assignments = []
	$scope.assignmentListMsg = {}
	$scope.assignment = _.cloneDeep defaultAssignment
	$scope.assignmentDetailsMsg = {}
	$scope.sandboxConfigFileDetails = null
	$scope.sandboxConfigMsg = {}

	$scope.listAssignments()
	$scope.asgId = $routeParams.id if $routeParams.id
	$scope.findAssignment($scope.asgId) if $scope.asgId
