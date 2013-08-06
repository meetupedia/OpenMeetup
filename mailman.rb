require 'mailman'


Mailman.config.pop3 = {
  server: 'mail.meetupedia.org',
  username: 'uzenet-teszt@meetupedia.org',
  password: 'almafa123',
  port: 995
}

Mailman::Application.run do

  to '%group%@meetupedia.org' do
    if user = User.find_by_email(message.sender)
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
