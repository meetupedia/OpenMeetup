# encoding: UTF-8

class TestMailer < ActionMailer::Base
  default_url_options[:host] = Settings.host
  default :from => Settings.default_email

  def report(email)
    # attachments['production.log'] = File.read('/var/www/get2gather/log/production.log')
    mail :to => email, :subject => 'report from test_mailer'
  end
end
