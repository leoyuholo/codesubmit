app = angular.module 'codesubmit-student'

app.service 'assignmentService', (urlService) ->
	self = {}

	self.listAssignments = (done) ->
		urlService.get urlService.assignment.list(), done

	return self
