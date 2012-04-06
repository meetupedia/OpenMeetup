class GroupMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def invitation(user, email, group, message)
    @user = user
    @group = group
    @message = message
    mail :to => email, :subject => "Meghívó: #{@group.name}"
  end
end
