# encoding: UTF-8

class UserMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def confirmation(user)
    @user = user
    mail :to => user.email, :subject => 'Regisztráció megerősítése'
  end

  def password_reset(user)
    @url = edit_password_url(user.perishable_token)
    mail :to => user.email, :subject => 'Jelszó megváltoztatása'
  end
end
