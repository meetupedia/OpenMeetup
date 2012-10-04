# encoding: UTF-8

class EventMailer < CommonMailer

  def absence(user, email, event)
    @user = user
    @event = event
    mail :to => email, :subject => "#{@user.name} is not coming to #{@event.name}"
  end

  def invitation(user, email, event)
    @user = user
    @event = event
    mail :to => email, :subject => "Invitation to #{@event.title}"
  end

  def participation(user, email, event)
    @user = user
    @event = event
    mail :to => email, :subject => "#{@user.name} is coming to #{@event.name}"
  end


  class Preview < MailView

    def absence
      absence = Absence.last
      mail = EventMailer.absence(absence.user, absence.event.group.admins.first.email, absence.event)
      mail
    end

    def invitation
      event_invitation = EventInvitation.last
      mail = EventMailer.invitation(event_invitation.user, event_invitation.email, event_invitation.event)
      mail
    end

    def participation
      participation = Participation.last
      mail = EventMailer.participation(participation.user, participation.event.group.admins.first.email, participation.event)
      mail
    end
  end
end
