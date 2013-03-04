# encoding: UTF-8

class TestMailer < CommonMailer

  def report(email)
    mail :to => email, :subject => 'report from test_mailer'
  end
end
