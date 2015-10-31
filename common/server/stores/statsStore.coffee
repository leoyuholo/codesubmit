
module.exports = ($) ->
	self = {}

	Stats = $.models.Stats

	self.findByTags = (tags, done) ->
		Stats.find {tags: $all: tags}, done

	self.upsert = (stats, done) ->
		Stats.update {statsId: stats.statsId}, stats, {upsert: true}, done

	return self
