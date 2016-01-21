_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = ($) ->
	stat =
		statsId: String
		tags: [String]
		max: {type: Number, default: 0}
		count: {type: Number, default: 0}
		updateDt: Date

	StatSchema = new mongoose.Schema(stat)

	StatSchema.index {statsId: 1}, {unique: 1}
	StatSchema.index {tags: 1}

	attrKeys = _.keys stat
	StatSchema.static 'envelop', (doc) ->
		_.pick doc, attrKeys

	mongoose.model 'Stat', StatSchema
