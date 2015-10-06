
module.exports = ($) ->
	Student = $.models.Student

	self = {}

	self.list = (done) ->
		Student.find {}, done

	self.findByEmail = (email, done) ->
		Student.findOne {email: email}, done

	self.create = (student, done) ->
		Student.create student, done

	self.update = (student, done) ->
		Student.update {email: student.email}, student, done

	return self
