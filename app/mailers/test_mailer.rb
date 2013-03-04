# encoding: UTF-8

class TestMailer < ActionMailer::Base
  default_url_options[:host] = Settings.host
  default :from => Settings.default_email

  def report(email)
    attachments['test.log'] = File.read(File.join(Rails.root, 'log/test.log'))
    mail :to => email, :subject => 'report from test_mailer'
  end
end
