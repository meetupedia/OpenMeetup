require 'mailman'


class MailmanMailer < CommonMailer

  def forward(user, message)
    @user = user
    @email = @user.email
    @message = message
    mail to: @email, subject: "Note from #{Settings.title}"
  end
end


Mailman.config.pop3 = {
  server: 'mail.inter.hu',
  username: 'tipogral',
  password: 'nqmkhqxa'
}

Mailman::Application.run do

  to 'meetupedia@moly.hu' do
    users = [User.first]
    users.each do |user|
      puts user.email
      puts message
      MailmanMailer.forward(user, message)
    end
  end
end
