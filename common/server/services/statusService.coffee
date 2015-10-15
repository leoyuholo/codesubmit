
module.exports = ($) ->
	self = {}

	jobStarted = jobFinished = 0

	self.startJob = (submission, done) ->
		jobStarted += 1
		done null

	self.finishJob = (submission, done) ->
		jobFinished += 1
		done null

	self.getJobStarted = (done) ->
		done null, jobStarted

	self.getJobFinished = (done) ->
		done null, jobFinished

	return self
