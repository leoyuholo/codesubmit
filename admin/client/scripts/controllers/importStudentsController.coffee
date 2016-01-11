app = angular.module 'codesubmit'

app.controller 'importStudentsController', ($scope, studentService, messageService) ->

	$scope.importDataMsg = {}
	$scope.progress = false
	$scope.log = ''

	$scope.importDataLocalStorageKey = 'importStudents'
	$scope.importDataAceOptions =
		maxLines: 30
		showGutter: false
		showInvisibles: true
	$scope.csvExample =
		"""
		username	email	remarks
		CHAN, Siu Ming	chansiuming@example.com	siuming
		CHAN, Tai Man	chantaiman@example.com	taiman
		"""
	$scope.csvExampleAceOptions =
		minLines: 3
		maxLines: 3
		showGutter: false
		showInvisibles: true
		readOnly: true

	$scope.importData = localStorage.getItem($scope.importDataLocalStorageKey)

	parseImportData = (str) ->
		parsed = Papa.parse str, {header: true}

		throw new Error("row #{parsed.errors[0].row}: #{parsed.errors[0].message}") if parsed.errors.length > 0

		return parsed.data

	appendLog = (str) ->
		$scope.log += "#{str}\n"

	$scope.importStudents = (importData) ->
		messageService.clear $scope.importDataMsg
		$scope.log = ''
		$scope.progress = false

		try
			students = parseImportData importData
		catch err
			return messageService.error $scope.importDataMsg, err.message

		$scope.progress =
			success: 0
			fail: 0
			total: students.length

		appendLog "[INFO]#{new Date()}: Start importing #{students.length} students"

		async.eachLimit students, 10, ( (student, done) ->
			data =
				username: student.username
				email: student.email
				remarks: student.remarks

			studentService.create data, (err) ->
				if err
					$scope.progress.fail++
					appendLog "[ERROR]#{new Date()}: Error while importing student [#{JSON.stringify data}], #{err.message}"
					return done null

				$scope.progress.success++
				appendLog "[INFO]#{new Date()}: Successfully imported student #{data.username}, #{data.email}"

				done null
		), (err) ->
			return appendLog "[ERROR]#{new Date()}: Import finished with error, #{err.message}" if err

			appendLog "[INFO]#{new Date()}: Finish importing #{students.length} students, #{$scope.progress.success} imported, #{$scope.progress.fail} failed."
