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
    if user = User.find_by_email(message.sender.address)
      if group = Group.find_by_permalink(params[:group])
        post = group.posts.create user: user, post: message.body.decoded
        Activity.create_from(post, user, group)
        (group.members - [user]).each do |recipient|
          begin
            PostMailer.notification(post.id, recipient.id).deliver
          rescue
          end
        end
      end
    end
  end
end
