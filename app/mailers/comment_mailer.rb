# encoding: UTF-8

class CommentMailer < CommonMailer

  def notification(comment, user)
    if @comment = Comment.find_by_id(comment_id) and user = User.find_by_id(user_id)
      @recipient = user
      @email = user.email
      set_locale @recipient.andand.locale
      mail :to => @email, :subject => "Notification about a new comment."
    end
  end


  class Preview < MailView

    def notification
      comment = Comment.last
      user = User.first
      mail = CommentMailer.notification(comment.id, user.id)
      mail
    end
  end
end
