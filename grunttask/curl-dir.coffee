path = require 'path'

_ = require 'lodash'

module.exports = (grunt, options) ->
	cdnUrls = require '../cdnfile'

	libDir = path.join __dirname, '..', 'common', 'public', 'libs'

	config =
		'all':
			src: cdnUrls
			dest: libDir
			router: (url) ->
				url.replace('https://ajax.googleapis.com/', '')
					.replace('https://cdn.rawgit.com/', '')
					.replace('https://cdnjs.cloudflare.com/', '')

	return config
