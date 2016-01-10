_ = require 'lodash'
passport = require 'passport'
passportLocal = require 'passport-local'
session = require 'express-session'
connectRedis = require 'connect-redis'

module.exports = ($) ->
	self = {}

	makeFromTemplate = (controllerTemplate, options) ->
		router = $.express.Router()

		routes = controllerTemplate

		if options?.include
			routes = _.pick controllerTemplate, options.include
		else if options?.exclude
			routes = _.omit controllerTemplate, options.exclude

		_.each routes, (route) ->
			router.use route()

		return router

	self.makeControllers = (options) ->
		controllerTemplates = $.controllerTemplates
		controllers = {}

		if options?.include
			controllers = _.mapValues options.include, (routes, controllerName) ->
				if routes == '*' || routes[0] == '*'
					makeFromTemplate controllerTemplates[controllerName]
				else
					makeFromTemplate controllerTemplates[controllerName], {include: routes}
		else if options?.exclude
			controllers = _.transform controllerTemplates, (result, controllerTemplate, controllerName) ->
				if !options.exclude[controllerName]
					result[controllerName] = makeFromTemplate controllerTemplate
				else if !(options.exclude[controllerName] == '*' || options.exclude[controllerName][0] == '*')
					result[controllerName] = makeFromTemplate controllerTemplate, {exclude: options.exclude[controllerName]}
		else
			controllers = _.mapValues controllerTemplates, makeFromTemplate

		return controllers

	self.makeApi = () ->
		router = $.express.Router()

		if $.controllers.userController
			# allow unauthorized access to api/user
			router.use '/user', $.controllers.userController

			# otherwise, require authentication
			router.use (req, res, done) ->
				return done() if req.isAuthenticated()
				done new Error 'Unauthorized access.'

		_.each $.controllers, (controller, name) ->
			router.use '/' + name.replace(/Controller$/, ''), controller if name != 'userController'

		router.use $.utils.errorResponse

		return router

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

					$.utils.rng.verifyPw user.password, user.salt, password, (err, valid) ->
						return $.utils.onError done, err if err
						return done null, false if !valid

						done null, user
		)

		RedisStore = connectRedis session
		app.use session
			store: new RedisStore(
				host: config.redis.host
				port: config.redis.port
				db: config.redis.db
			)
			secret: config.sessionSecret
			cookie:
				maxAge: 2419200000
			name: config.sessionName
			resave: true
			saveUninitialized: true
		app.use passport.initialize()
		app.use passport.session()

	self.makeUserController = (userStore) ->
		configPassport $.app, $.config, userStore

		router = $.express.Router()

		router.post '/login', (req, res, done) ->
			passport.authenticate('local', (err, user, info) ->
				return $.utils.onError done, err if err
				return done new Error 'Incorrect email or password.' if !user

				req.logIn user, (err) ->
					return $.utils.onError done, _.set(new Error('Login error.'), 'debugInfo', {errorMessage: err.message, email: user.email}) if err

					res.json
						success: true
						user:
							email: user.email
							username: user.username
			) req, res, done

		router.get '/logout', (req, res, done) ->
			req.logout()
			res.json
				success: true

		return router

	return self
