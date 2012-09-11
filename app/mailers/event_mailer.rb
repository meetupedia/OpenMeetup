# encoding: UTF-8

class EventMailer < CommonMailer

  def invitation(user, event_invitation)
    @user = event_invitation.user
    @event = event_invitation.event
    @message = event_invitation.message
    mail :to => event_invitation.email, :subject => "Meghívó: #{@event.title}"
  end
end
