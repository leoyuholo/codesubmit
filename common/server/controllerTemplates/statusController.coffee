
module.exports = ($) ->
	self = {}

	self.jobstarted = () ->
		$.express.Router().get '/jobstarted', (req, res, done) ->
			$.services.statusService.getJobStarted (err, count) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					count: count

	self.jobfinished = () ->
		$.express.Router().get '/jobfinished', (req, res, done) ->
			$.services.statusService.getJobFinished (err, count) ->
				return $.utils.onError done, err if err

				res.json
					success: true
					count: count

	return self
