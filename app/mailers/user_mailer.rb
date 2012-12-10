# encoding: UTF-8

class UserMailer < CommonMailer

  def set_admin(recipient)
    @recipient = recipient
    @email = @recipient.email
    mail :to => @email, :subject => 'Your are admin now'
  end

  class Preview < MailView

    def set_admin
      user = User.first
      mail = UserMailer.set_admin(user)
      mail
    end
  end
end
