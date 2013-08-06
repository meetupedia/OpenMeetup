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

  to '%group%@moly.hu' do
    puts message.inspect
    if user = User.find_by_email(message.from)
      puts user.inspect
      if group = Group.find_by_permalink(params[:group])
        puts group.inspect
        group.posts.create post: message.body, user: user
      end
    end
  end
end
