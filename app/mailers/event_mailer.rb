# encoding: UTF-8

class EventMailer < ActionMailer::Base
  default_url_options[:host] = Settings.host
  default :from => Settings.default_email

  def invitation(user, email, event, message)
    @user = user
    @event = event
    @message = message
    mail :to => email, :bcc => 'andris@szimpatikus.hu', :subject => "Meghívó: #{@event.title}"
  end
end
