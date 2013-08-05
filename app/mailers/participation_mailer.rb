# encoding: UTF-8

class ParticipationMailer < CommonMailer

  def participation(participation)
    @user = participation.user
    @recipient = @user
    @email = @recipient.email
    @event = participation.event
    attachments["#{@event.permalink}.ics"] = @event.to_ics
    mail to: @email, subject: "You are going to #{@event.name}"
  end


  class Preview < MailView

    def participation
      participation = Participation.last
      mail = ParticipationMailer.participation(participation)
      mail
    end
  end
end
