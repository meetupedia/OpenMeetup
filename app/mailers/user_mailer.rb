# encoding: UTF-8

class UserMailer < ActionMailer::Base
  helper :application
  layout 'mailer'
  default_url_options[:host] = Settings.host
  default :from => Settings.default_email

  def confirmation(user)
    @user = user
    mail :to => user.email, :subject => 'Regisztráció megerősítése'
  end

  def password_reset(user)
    @url = edit_password_url(user.perishable_token)
    mail :to => user.email, :subject => 'Jelszó megváltoztatása'
  end

  def test(user, group)
    @user = user
    @group = group
    mail :to => @user.email, :subject => 'Tesztüzenet'
  end


  class Preview < MailView

    def test
      user = User.first
      group = Group.find('eckermann-klub')
      mail = UserMailer.test(user, group)
      mail
    end
  end
end
