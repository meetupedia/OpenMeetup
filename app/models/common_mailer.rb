# encoding: UTF-8

class CommonMailer < ActionMailer::Base
  helper :common
  helper :application
  layout 'mailer'
  default_url_options[:host] = Settings.host
  default :from => Settings.default_email

  def perform_caching
    false
  end
end