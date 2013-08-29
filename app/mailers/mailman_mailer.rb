# encoding: UTF-8

class MailmanMailer < CommonMailer

  def bounce(message)
    @message = message
    @email = message.from.first
    mail to: @email, subject: "E-mail not delivered!"
  end
end
