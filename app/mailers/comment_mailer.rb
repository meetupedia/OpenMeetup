# encoding: UTF-8

class CommentMailer < CommonMailer

  def notification(comment, user)
    @recipient = user
    @email = @recipient.email
    @comment = comment
    set_locale @recipient.andand.locale
    mail :to => @email, :subject => "Notification about a new comment."
  end


  class Preview < MailView

    def notification
      comment = Comment.last
      user = User.first
      mail = CommentMailer.notification(comment, user)
      mail
    end
  end
end
