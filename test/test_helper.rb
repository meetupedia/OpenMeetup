ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'

class ActiveSupport::TestCase
  # def self.inherited(subclass)
  #   subclass.instance_eval do
  #     setup :activate_authlogic
  #   end
  # end

  fixtures :all

  # def setup
  #   @current_user = UserSession.create(users(:one))
  # end
end
