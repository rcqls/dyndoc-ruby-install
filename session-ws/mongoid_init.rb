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

class SessionQuestion
  include Mongoid::Document
  field :session
end
