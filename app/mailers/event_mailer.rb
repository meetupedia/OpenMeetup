# encoding: UTF-8

class EventMailer < ActionMailer::Base
  default_url_options[:host] = Settings.host
  default :from => Settings.default_email

  def invitation(user, event_invitation)
    @user = event_invitation.user
    @event = event_invitation.event
    @message = event_invitation.message
    mail :to => event_invitation.email, :subject => "Meghívó: #{@event.title}"
  end
end
