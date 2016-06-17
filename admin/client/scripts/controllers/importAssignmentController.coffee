app = angular.module 'codesubmit'

app.controller 'importAssignmentController', ($scope, $uibModalInstance, messageService) ->

	$scope.assignmentJson = ''
	$scope.localStorageKey = 'importAssignment'

	$scope.importAssignmentMsg = {}

	$scope.importAssignmentAceOptions =
		showGutter: false
		readOnly: false

	$scope.importAssignment = () ->
		try
			assignment = JSON.originalParse $scope.assignmentJson
		catch e
			return messageService.error $scope.importAssignmentMsg, e.message
		$uibModalInstance.close JSON.parse $scope.assignmentJson

	$scope.assignmentJson = localStorage.getItem($scope.localStorageKey) || ''
