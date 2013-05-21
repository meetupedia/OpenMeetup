# encoding: UTF-8

class EventMailer < CommonMailer

  def new_event(event, recipient)
    @recipient = recipient
    @email = @recipient.email
    @event = event
    @user = @event.user
    mail :to => @email, :subject => "#{@user.name} has created a new event: #{@event.name}"
  end

  def absence(absence, recipient)
    @recipient = recipient
    @email = @recipient.email
    @user = absence.user
    @event = absence.event
    mail :to => @email, :subject => "#{@user.name} is not coming to #{@event.name}"
  end

  def participation(participation, recipient)
    @recipient = recipient
    @email = @recipient.email
    @user = participation.user
    @event = participation.event
    mail :to => @email, :subject => "#{@user.name} is coming to #{@event.name}"
  end


  class Preview < MailView

    def event
      event = Event.last
      mail = EventMailer.event(event, User.first)
      mail
    end

    def absence
      absence = Absence.last
      mail = EventMailer.absence(absence, User.first)
      mail
    end

    def participation
      participation = Participation.last
      mail = EventMailer.participation(participation, participation.event.group.admins.first)
      mail
    end
  end
end
