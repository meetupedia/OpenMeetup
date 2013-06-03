# encoding: UTF-8

class TestMailer < ActionMailer::Base
  default_url_options[:host] = Settings.host
  default from: Settings.default_email

  def report(email)
    attachments['production_small.log'] = File.read(File.join(Rails.root, 'log/production_small.log'))
    attachments['whenever-error_small.log'] = File.read(File.join(Rails.root, 'log/whenever-error_small.log'))
    mail to: email, subject: 'report from test_mailer'
  end
end
