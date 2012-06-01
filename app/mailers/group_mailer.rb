# -*- encoding : utf-8 -*-

class GroupMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def invitation(user, email, group, message)
    @user = user
    @group = group
    @message = message
    mail :to => email, :subject => "Meghívó: #{@group.name}"
  end

  def join(user, email, group)
    @user = user
    @group = group
    mail :to => email, :subject => "Csatlakozás: #{@group.name}"
  end
end
