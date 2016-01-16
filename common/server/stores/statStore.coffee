
module.exports = ($) ->
	self = {}

	Stat = $.models.Stat

	self.findByTags = (tags, done) ->
		Stat.find {tags: $all: tags}, done

	self.upsert = (stat, done) ->
		Stat.update {statId: stat.statId}, stat, {upsert: true}, done

	return self
