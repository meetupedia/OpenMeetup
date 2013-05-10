# encoding: UTF-8

class CommentMailer < CommonMailer

  def notification(comment_id, user_id)
    if @comment = Comment.find_by_id(comment_id) and @recipient = User.find_by_id(user_id)
      @email = @recipient.email
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
