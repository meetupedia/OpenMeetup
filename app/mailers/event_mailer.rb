# encoding: UTF-8

class EventMailer < CommonMailer

  def absence(absence, recipient)
    @recipient = recipient
    @email = @recipient.email
    @user = absence.user
    @event = absence.event
    mail :to => @email, :subject => "#{@user.name} is not coming to #{@event.name}"
  end

  def invitation(event_invitation)
    @recipient = event_invitation.invited_user if event_invitation.invited_user
    @email = event_invitation.email
    @user = event_invitation.user
    @event = event_invitation.event
    mail :to => @email, :subject => "Invitation to #{@event.title}"
  end

  def participation(participation, recipient)
    @recipient = recipient
    @email = @recipient.email
    @user = participation.user
    @event = participation.event
    mail :to => @email, :subject => "#{@user.name} is coming to #{@event.name}"
  end


  class Preview < MailView

    def absence
      absence = Absence.last
      mail = EventMailer.absence(absence, User.first)
      mail
    end

    def invitation
      event_invitation = EventInvitation.last
      mail = EventMailer.invitation(event_invitation)
      mail
    end

    def participation
      participation = Participation.last
      mail = EventMailer.participation(participation, participation.event.group.admins.first)
      mail
    end
  end
end
