_ = require 'lodash'

module.exports = ($) ->
	self = {}

	makeStatsId = (tags) ->
		tags.sort().join '/'

	makeTags = (tags) ->
		return _.map(tags, (v, k) -> "#{k}:#{v}") if _.isObject tags
		return [tags] if _.isString tags
		return tags if _.isArray tags

	resolveTags = (tags) ->
		_.zipObject _.invoke tags, 'split', ':'

	self.findByTags = (tags, done) ->
		$.stores.statsStore.findByTags makeTags(tags), (err, statses) ->
			return $.utils.onError done, err if err

			done null, _.map _.map(statses, $.models.Stats.envelop), (stats) ->
				stats.tags = resolveTags stats.tags
				return stats

	self.update = (stats, done) ->
		stats.tags = makeTags stats.tags
		stats.statsId = makeStatsId stats.tags

		$.stores.statsStore.upsert stats, (err) ->
			return $.utils.onError done, err if err

			done null, stats

	return self
