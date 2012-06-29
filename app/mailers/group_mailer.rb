# -*- encoding : utf-8 -*-

class GroupMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def invitation(user, group_invitation)
    @user = group_invitation.user
    @group = group_invitation.group
    @message = group_invitation.message
    mail :to => group_invitation.email, :subject => "Meghívó: #{@group.name}"
  end

  def join(user, email, group)
    @user = user
    @group = group
    mail :to => email, :subject => "Csatlakozás: #{@group.name}"
  end
end
