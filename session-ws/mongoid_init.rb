require 'mongoid'

Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__),:development)

class SessionAdmin
  include Mongoid::Document
  field :login, type: String
  field :passwd, type: String
end

class SessionUser
  include Mongoid::Document
  field :login, type: String
  field :passwd, type: String
  field :first_name, type: String
  field :last_name, type: String
  # Optional
  field :email, type: String, default: ""
  field :year, type: String, default: ""
  field :section, type: String, default: ""
  field :group, type: String, default: ""
  field :comment, type: String, default: ""
  # MetaData
  field :register_time, type: Time, default: ->{ Time.now }
end

class QuestionForm
  include Mongoid::Document
  field :form_id, type: String
  field :form_passwd, type: String
  field :form_time, type: Time, default: ->{ Time.now }
  embeds_many :user_answers, class_name: "UserAnswer"
end

class UserAnswer
  include Mongoid::Document
  field :login, type: String
  field :question_answers, type: Hash
  embedded_in :question_form, class_name: "QuestionForm"
end

# a=QuestionForm.new({form_id: "toto", form_passwd: "titi"})
# b=a.user_answers.build({login: "god",question_answers: {test: "q1", test2: "q3"}})
# b.save
# a.save
# b=a.user_answers.build({login: "r",question_answers: {test: "q2", test2: "q3"}})
# b.save
# a.save

# Create directly
# QuestionForm.where(form_id: "toto",passwd: "titi").first.user_answers.create({login: "r2",question_answers: {test: "q2", test2: "q3"}})

# Update attributes in UserAnswer
#a=QuestionForm.where(form_id: "toto",form_passwd: "titi").
#  first.user_answers.select {|e| e.login =="god"}.
#  first.update_attributes({login: "GOD"})
#a=QuestionForm.where(form_id: "toto",form_passwd: "titi").first.user_answers.select {|e| e.login =="GOD"}.first.update_attributes({question_answers: {test: "q1",test2: "q2", test3: "q3"}})

# R side:
# mongo(db="mongoid",col="question_forms") -> m
# m$find('{"form_id": "toto","form_passwd": "titi"}')$user_answers[[1]][,-1] #all but the useless _id
