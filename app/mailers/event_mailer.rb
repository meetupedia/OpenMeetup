# encoding: UTF-8

class EventMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def invitation(user, email, event, message)
    @user = user
    @event = event
    @message = message
    mail :to => email, :bcc => 'andris@szimpatikus.hu', :subject => "Meghívó: #{@event.title}"
  end
end
