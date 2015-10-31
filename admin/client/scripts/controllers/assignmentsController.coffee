app = angular.module 'codesubmit'

app.controller 'AssignmentsController', ($scope, $routeParams, assignmentService, messageService, redirectService, storageService, urlService) ->

	editor = {}

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

	$scope.assignments = []
	$scope.assignmentListMsg = {}
	$scope.assignment = _.cloneDeep defaultAssignment
	$scope.assignmentDetailsMsg = {}
	$scope.testCaseFileDetails = null
	$scope.testCaseMsg = {}
	$scope.asgId = $routeParams.asgid if $routeParams.asgid

	$scope.createAssignment = (assignment) ->
		assignmentService.create assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment created.'

			redirectService.redirectTo 'assignments', data.assignment.asgId

	$scope.updateAssignment = (assignment, properties) ->
		assignment.sandboxConfig.testCaseNames = _.invoke assignment.sandboxConfig.testCaseNames.split(','), 'trim' if _.isString assignment.sandboxConfig?.testCaseNames

		assignmentService.update assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment updated.'

	$scope.uploadTestCaseFile = () ->
		testCaseFile = document.getElementById('testCase-input').files?[0]

		return messageService.error $scope.testCaseMsg, 'No file chosen.' if !testCaseFile
		return messageService.error $scope.testCaseMsg, "Test cases [#{testCaseFile.type || 'no type'}] file type is not supported" if -1 == testCaseFile.type?.indexOf?('zip')

		storageService.post $scope.assignment.testCaseFileStorageKey, testCaseFile, (err) ->
			return messageService.error $scope.testCaseMsg, err.message if err
			messageService.success $scope.testCaseMsg, 'Test cases uploaded.'

			getTestCaseFileDetails $scope.assignment.testCaseFileStorageKey

	listAssignments = () ->
		assignmentService.list (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			$scope.assignments = data.assignments

	findAssignment = (asgId) ->
		assignmentService.findByAsgId asgId, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err

			$scope.assignment = data.assignment

			getTestCaseFileDetails $scope.assignment.testCaseFileStorageKey

	getTestCaseFileDetails = (key) ->
		$scope.testCaseFileDetails = null

		storageService.findByKey key, (err, data) ->
			return if err && 'File not found.' == err.message
			return messageService.error $scope.testCaseMsg, err.message if err

			$scope.testCaseFileDetails = data.info
			$scope.testCaseFileDetails.filename = $scope.assignment.name + '.zip'
			$scope.testCaseFileDetails.downloadUrl = urlService.storage.get key, $scope.testCaseFileDetails.filename

	listAssignments()
	findAssignment($scope.asgId) if $scope.asgId
