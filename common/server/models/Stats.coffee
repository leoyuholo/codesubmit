_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = ($) ->
	stats =
		statsId: String
		tags: [String]
		max: {type: Number, default: 0}
		count: {type: Number, default: 0}
		updateDt: Date

	StatsSchema = new mongoose.Schema(stats)

	StatsSchema.index {statsId: 1}, {unique: 1}
	StatsSchema.index {tags: 1}

	attrKeys = _.keys stats
	StatsSchema.static 'envelop', (doc) ->
		_.pick doc, attrKeys

	mongoose.model 'Stats', StatsSchema
