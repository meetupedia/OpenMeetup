# encoding: UTF-8

class PostMailer < CommonMailer

  def notification(post_id, user_id)
    if @post = Post.find_by_id(post_id) and user = User.find_by_id(user_id)
      @recipient = user
      @email = user.email
      @postable = @post.postable
      set_locale @recipient.andand.locale
      mail :to => @email, :subject => "Notification about a new post: #{@postable.name}"
  end


  class Preview < MailView

    def notification
      post = Post.last
      user = User.first
      mail = PostMailer.notification(post.id, user.id)
      mail
    end
  end
end
