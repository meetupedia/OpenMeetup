# encoding: UTF-8

class UserMailer < CommonMailer

  def password_reset(user)
    @user = user
    @email = @user.email
    @url = edit_password_url(@user.perishable_token)
    mail :to => @email, :subject => 'Request new password'
  end

  def set_admin(user)
    @user = user
    @email = @user.email
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
