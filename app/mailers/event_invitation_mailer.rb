# encoding: UTF-8

class EventInvitationMailer < CommonMailer

  def invitation(event_invitation)
    @recipient = event_invitation.invited_user if event_invitation.invited_user
    @email = event_invitation.email
    @user = event_invitation.user
    @event = event_invitation.event
    @message = event_invitation.message
    @invitation_code = event_invitation.code
    mail :to => @email, :subject => "Invitation to #{@event.title}"
  end


  class Preview < MailView

    def invitation
      event_invitation = EventInvitation.last
      mail = EventInvitationMailer.invitation(event_invitation)
      mail
    end
  end
end
