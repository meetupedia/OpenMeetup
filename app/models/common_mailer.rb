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

  def set_locale(locale)
    I18n.locale = locale
    Thread.current[:tr8n_current_language] = Tr8n::Language.for(I18n.locale)
  end
end
