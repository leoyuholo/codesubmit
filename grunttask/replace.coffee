
module.exports = (grunt, options) ->
	http = grunt.option('http') || 'http'
	port = grunt.option('livereload') || 35729
	from = '</body>'
	to = "<script>(function(){document.write('<script src=\"#{http}://' + window.location.hostname + ':#{port}/livereload.js\" type=\"text/javascript\"><\\\/script>')}).call(this);</script></body>"
	config =
		admin:
			src: ['admin/public/**/*.html']
			overwrite: true
			replacements: [
				{from: from, to: to}
			]
		student:
			src: ['student/public/**/*.html']
			overwrite: true
			replacements: [
				{from: from, to: to}
			]

	return config
