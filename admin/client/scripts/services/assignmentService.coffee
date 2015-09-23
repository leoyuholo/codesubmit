app = angular.module 'codesubmit-admin'

app.service 'assignmentService', (urlService) ->
	self = {}

	self.listAssignments = (done) ->
		urlService.get urlService.assignment.list(), done

	self.findAssignment = (asgId, done) ->
		urlService.get urlService.assignment.findByAsgId(asgId), done

	self.createAssignment = (assignment, done) ->
		payload =
			assignment: assignment

		urlService.post urlService.assignment.create(), payload, done

	self.updateAssignment = (assignment, done) ->
		payload =
			assignment: assignment

		urlService.post urlService.assignment.update(), payload, done

	return self
