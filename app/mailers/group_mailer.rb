class GroupMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def invitation(email, group, message)
    @group = group
    @message = message
    mail :to => email, :subject => "Meghívó: #{@group.name}"
  end
end
