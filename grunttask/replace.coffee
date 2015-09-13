
module.exports = (grunt, options) ->
	http = grunt.option('http') || 'http'
	port = grunt.option('livereload') || 35729
	config =
		admin:
			src: ['admin/public/**/*.html']
			overwrite: true
			replacements: [
				{from: '</body>', to: "<script>(function(){document.write('<script src=\"#{http}://' + window.location.hostname + ':#{port}/livereload.js\" type=\"text/javascript\"><\\\/script>')}).call(this);</script></body>"}
			]

	return config
