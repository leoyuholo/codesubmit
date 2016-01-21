_ = require 'lodash'

module.exports = ($) ->
	self = {}

	makeStatId = (tags) ->
		tags.sort().join '/'

	makeTags = (tags) ->
		return _.map(tags, (v, k) -> "#{k}:#{v}") if _.isObject tags
		return [tags] if _.isString tags
		return tags if _.isArray tags

	resolveTags = (tags) ->
		_.zipObject _.invoke tags, 'split', ':'

	self.findByTags = (tags, done) ->
		$.stores.statStore.findByTags makeTags(tags), (err, stats) ->
			return $.utils.onError done, err if err

			done null, _.map _.map(stats, $.models.Stat.envelop), (stat) ->
				stat.tags = resolveTags stat.tags
				return stat

	self.update = (stat, done) ->
		stat.tags = makeTags stat.tags
		stat.statsId = makeStatId stat.tags

		$.stores.statStore.upsert stat, (err) ->
			return $.utils.onError done, err if err

			done null, stat

	return self
