# encoding: UTF-8

class UserMailer < CommonMailer

  def password_reset(user)
    @user = user
    @email = @user.email
    mail to: @email, subject: 'Request new password'
  end

  def set_admin(user)
    @user = user
    @email = @user.email
    mail to: @email, subject: 'Your are admin now'
  end

  def newsletter_insights_for_group_admin(user)
    @user = user
    @email = @user.email
    @admined_groups = @user.admined_groups
    mail to: @email, subject: 'Your weekly group update'
  end

  class Preview < MailView

    def set_admin
      user = User.first
      mail = UserMailer.set_admin(user)
      mail
    end

    def newsletter_insights_for_group_admin
      user = User.first
      mail = UserMailer.newsletter_insights_for_group_admin(user)
      mail
    end

  end
end
