app = angular.module 'codesubmit-admin'

app.controller 'AssignmentsController', ($scope, $routeParams, assignmentService, messageService, redirectService, storageService) ->

	$scope.assignments = []
	$scope.assignmentListMsg = {}

	$scope.listAssignments = () ->
		assignmentService.listAssignments (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			$scope.assignments = data.assignments

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

	$scope.assignment = _.cloneDeep defaultAssignment
	$scope.assignmentDetailsMsg = {}

	$scope.assignment.asgId = $routeParams.id if $routeParams.id

	getSandboxConfigFileDetails = (key) ->
		storageService.findByKey key, (err, data) ->
			return messageService.error $scope.sandboxConfigMsg, err.message if err

			$scope.sandboxConfigFileDetails = data.info
			$scope.sandboxConfigFileDetails.filename = $scope.assignment.name.replace /\W/, '_'

	$scope.findAssignment = (asgId) ->
		assignmentService.findAssignment asgId, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err

			$scope.assignment = data.assignment

			getSandboxConfigFileDetails $scope.assignment.sandboxConfigFileStorageKey

	$scope.createAssignment = (assignment) ->
		assignmentService.createAssignment assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment created.'

			redirectService.redirectToAssignment data.assignment.asgId

	$scope.updateAssignment = (assignment) ->
		assignmentService.updateAssignment assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment updated.'

	$scope.sandboxConfigFileDetails = {}
	$scope.sandboxConfigMsg = {}

	$scope.uploadSandboxConfigFile = () ->
		sandboxConfigFile = document.getElementById('sandboxConfig-input').files?[0]

		return messageService.error $scope.sandboxConfigMsg, 'No file chosen.' if !sandboxConfigFile
		return messageService.error $scope.sandboxConfigMsg, "Sandbox config [#{sandboxConfigFile.type || 'no type'}] file type is not supported" if 'application/zip' != sandboxConfigFile.type

		storageService.post $scope.assignment.sandboxConfigFileStorageKey, sandboxConfigFile, (err) ->
			return messageService.error $scope.sandboxConfigMsg, err.message if err
			messageService.success $scope.sandboxConfigMsg, 'Sandbox config uploaded.'

	$scope.listAssignments()
	$scope.findAssignment($scope.assignment.asgId) if $scope.assignment.asgId
