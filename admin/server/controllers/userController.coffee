passport = require 'passport'
passportLocal = require 'passport-local'
session = require 'express-session'
connectRedis = require 'connect-redis'

$ = require '../globals'

configPassport = (app, config, userStore) ->
	passport.serializeUser (user, done) ->
		done null, user.email

	passport.deserializeUser (email, done) ->
		userStore.findByEmail email, done

	localStrategyOptions =
		usernameField: 'email'
		passwordField: 'password'

	passport.use new passportLocal.Strategy(
		localStrategyOptions, (email, password, done) ->
			userStore.findByEmail email, (err, user) ->
				return $.utils.onError done, err if err

				return done null, false if !user
				return done null, false if user.password != password
				done null, user
	)

	RedisStore = connectRedis session
	app.use session
		store: new RedisStore(
			host: config.redis.host
			port: config.redis.port
		)
		secret: config.sessionSecret
		cookie:
			maxAge: 2419200000
		name: config.sessionName
		resave: true
		saveUninitialized: true
	app.use passport.initialize()
	app.use passport.session()

configPassport($.app, $.config, $.stores.adminStore)

router = $.express.Router()

router.post '/login', (req, res, done) ->
	passport.authenticate('local', (err, user, info) ->
		return $.utils.onError done, err if err
		return $.utils.onError done, new Error 'Incorrect email or password.' if !user

		req.logIn user, (err) ->
			return $.utils.onError done, new Error 'Login error.' if err

			res.json
				success: true
				user:
					email: user.email
					username: user.username
	)(req, res, done)

router.get '/logout', (req, res, done) ->
	req.logout()
	res.json
		success: true

module.exports = router
