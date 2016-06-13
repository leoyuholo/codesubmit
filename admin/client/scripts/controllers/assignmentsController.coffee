app = angular.module 'codesubmit'

app.controller 'assignmentsController', ($scope, $routeParams, assignmentService, messageService, redirectService, storageService, urlService) ->

	editor = {}

	newDate = new Date()
	newDate.setMilliseconds 0
	newDate.setSeconds 0

	newDueDate = new Date(newDate)
	newDueDate.setDate newDueDate.getDate() + 14

	defaultAssignment =
		name: ''
		startDt: newDate
		dueDt: newDueDate
		hardDueDt: newDueDate
		submissionLimit: 100
		penalty: 0

	$scope.now = new Date()

	$scope.assignments = []
	$scope.assignmentListMsg = {}
	$scope.assignment = _.cloneDeep defaultAssignment
	$scope.assignmentDetailsMsg = {}
	$scope.testCaseFileDetails = null
	$scope.testCaseMsg = {}
	$scope.testCaseFileNames = []
	$scope.asgId = $routeParams.asgid if $routeParams.asgid
	$scope.forms = {}

	$scope.createAssignment = (assignment) ->
		assignmentService.create assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment created.'

			redirectService.redirectTo 'assignments', data.assignment.asgId

	$scope.updateAssignment = (assignment) ->
		return messageService.error $scope.assignmentDetailsMsg, 'Invalid form.' if !$scope.forms.generalForm.$valid || !$scope.forms.sandboxConfigForm.$valid
		assignment.sandboxConfig.testCaseNames = _.invoke assignment.sandboxConfig.testCaseNames.split(','), 'trim' if _.isString assignment.sandboxConfig?.testCaseNames

		assignmentService.update assignment, (err, data) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment updated.'

	deleteAssignment = (assignment) ->
		assignmentService.remove assignment, (err) ->
			return messageService.error $scope.assignmentDetailsMsg, err.message if err
			messageService.success $scope.assignmentDetailsMsg, 'Assignment deleted.'
			redirectService.redirectTo 'assignments'

	$scope.deleteAssignment = (assignment) ->
		deleteAssignment assignment if confirm "Click OK to delete assignment [#{assignment.name}] Assignment Id:[#{assignment.asgId}]."

	$scope.testCaseFileChange = () ->
		testCaseFile = document.getElementById('testCase-input').files?[0]

		if !testCaseFile
			$scope.testCaseFileNames = []
			$scope.$digest()
			return

		storageService.readZipFileNames testCaseFile, (err, fileNames) ->
			return messageService.error $scope.testCaseMsg, err.message if err

			$scope.testCaseFileNames = fileNames

			$scope.$digest()

	$scope.uploadTestCaseFile = () ->
		testCaseFile = document.getElementById('testCase-input').files?[0]

		return messageService.error $scope.testCaseMsg, 'No file chosen.' if !testCaseFile
		return messageService.error $scope.testCaseMsg, "Test cases [#{testCaseFile.type || 'no type'}] file type is not supported" if -1 == testCaseFile.type?.indexOf?('zip')

		storageService.readZipFolderNames testCaseFile, (err, testCaseNames) ->
			return messageService.error $scope.testCaseMsg, err.message if err

			async.parallel [
				_.partial assignmentService.updateTestCaseNames, $scope.assignment.asgId, testCaseNames
				_.partial storageService.post, $scope.assignment.testCaseFileStorageKey, testCaseFile
			], (err) ->
				return messageService.error $scope.testCaseMsg, err.message if err
				messageService.success $scope.testCaseMsg, 'Test cases uploaded.'

				$scope.assignment.sandboxConfig.testCaseNames = testCaseNames

				getTestCaseFileDetails $scope.assignment.testCaseFileStorageKey

	listAssignments = () ->
		assignmentService.list (err, data) ->
			return messageService.error $scope.assignmentListMsg, err.message if err

			now = Date.now()
			$scope.assignments = _.flatten _.map (_.partition data.assignments, (a) -> a.dueDt >= now), assignmentService.sort

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

			$scope.testCaseFileDetails = data.fileInfo
			$scope.testCaseFileDetails.filename = $scope.assignment.name + '.zip'
			$scope.testCaseFileDetails.downloadUrl = urlService.storage.get key, $scope.testCaseFileDetails.filename

	listAssignments()
	findAssignment($scope.asgId) if $scope.asgId
