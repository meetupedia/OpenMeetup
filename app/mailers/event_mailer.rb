class EventMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def invitation(email, event, message)
    @event = event
    @message = message
    mail :to => email, :subject => "Meghívó: #{@event.title}"
  end
end
