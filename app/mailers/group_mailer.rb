# encoding: UTF-8

class GroupMailer < CommonMailer

  def join(user, email, group)
    @user = user
    @group = group
    mail :to => email, :subject => "Csatlakozás: #{@group.name}"
  end


  class Preview < MailView
  end
end
