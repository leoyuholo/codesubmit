
module.exports = (grunt, options) ->
	opts =
		removeComments: true
		collapseWhitespace: true
		conservativeCollapse: true
		minifyJS:
			mangle: false
		minifyCSS: true

	config =
		html:
			options: opts
			files:
				'admin/public/index.html': 'admin/public/index.html'
				'student/public/index.html': 'student/public/index.html'

	return config
