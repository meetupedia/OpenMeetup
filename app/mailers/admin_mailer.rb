# encoding: UTF-8

class AdminMailer < CommonMailer

  def feedback(feedback_id, user_id)
    if @feedback = Feedback.find_by_id(feedback_id) and @recipient = User.find_by_id(user_id)
      if @email = @recipient.email
        mail to: @email, subject: 'New feedback'
      end
    end
  end

  def weekly_report(user_id)
    if @recipient = User.find_by_id(user_id)
      @email = @recipient.email
      mail to: @email, subject: 'Weekly report'
    end
  end


  class Preview < MailView

    def feedback
      mail = AdminMailer.feedback(Feedback.first.id, User.first.id)
      mail
    end

    def weekly_report
      mail = AdminMailer.weekly_report(User.first.id)
      mail
    end
  end
end
