crypto = require 'crypto'

shortid = require 'shortid'
uuid = require 'node-uuid'

module.exports = ($) ->
	self = {}

	self.generateUuid = () ->
		uuid.v4()

	self.generateId = () ->
		shortid.generate()

	self.generatePw = () ->
		shortid.generate()

	self.hashPw = (email, password) ->
		# TODO: make life harder
		# password = password + email + $.config.origin
		password = password + email

		crypto.createHash('sha512')
			.update(password)
			.digest 'hex'

	self.generateSalt = (done) ->
		crypto.randomBytes 64, (err, salt) ->
			return $.utils.onError done, err if err

			done null, salt.toString 'hex'

	self.secureHashPwWithSalt = (password, salt, done) ->
		crypto.pbkdf2 password, new Buffer(salt, 'hex'), 100000, 512, 'sha512', (err, hash) ->
			return $.utils.onError done, err if err

			done null, hash.toString 'hex'

	self.secureHashPw = (password, done) ->
		# TODO: use async
		self.generateSalt (err, salt) ->
			return $.utils.onError done, err if err

			self.secureHashPwWithSalt password, salt, (err, hash) ->
				return $.utils.onError done, err if err

				done null, hash, salt

	self.hashPlainPw = (email, password, done) ->
		$.logger.log 'info', "Password for #{email} is [#{password}]" if $.env.development
		self.secureHashPw self.hashPw(email, password), done

	self.verifyPw = (hash, salt, against, done) ->
		self.secureHashPwWithSalt against, salt, (err, againstHash) ->
			return $.utils.onError done, err if err

			done null, hash == againstHash.toString 'hex'

	return self
