# encoding: UTF-8

class AdminMailer < CommonMailer

  def feedback(feedback_id, user_id, sender_id, request_url)
    if @feedback = Feedback.find_by_id(feedback_id) and @recipient = User.find_by_id(user_id) and @sender = User.find_by_id(sender_id)
      if @email = @recipient.email
        @request_url = request_url
        mail to: @email, from: @sender.email, subject: 'New feedback'
      end
    end
  end

  def weekly_newsletter(user_id)
    if @recipient = User.find_by_id(user_id)
      @groups = Group.where('created_at > ?', 1.week.ago).order('created_at ASC')
      @groups = @groups.where(city_id: @recipient.city_id) unless Settings.standalone
      @events = Event.where(group_id: @recipient.joined_group_ids).where('start_time > ? AND start_time < ?', Time.now, 1.week.from_now).order('start_time ASC')
      if @groups.present? or @events.present?
        @user = @recipient
        @email = @recipient.email
        mail to: @email, subject: 'Weekly report'
      end
    end
  end


  class Preview < MailView

    def feedback
      mail = AdminMailer.feedback(Feedback.first.id, User.first.id)
      mail
    end

    def weekly_newsletter
      mail = AdminMailer.weekly_newsletter(User.first.id)
      mail
    end
  end
end
