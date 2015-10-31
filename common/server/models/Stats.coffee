_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = ($) ->
	stats =
		statsId: String
		tags: [String]
		max: Number
		count: Number
		updateDt: Date

	StatsSchema = new mongoose.Schema(stats)

	StatsSchema.index {statsId: 1}, {unique: 1}
	StatsSchema.index {tags: 1}

	StatsSchema.static 'envelop', (doc) ->
		_.pick doc, _.keys stats

	mongoose.model 'Stats', StatsSchema
