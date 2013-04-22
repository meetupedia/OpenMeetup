# encoding: UTF-8

class AdminMailer < CommonMailer

  def weekly_report(user_id)
    if @user = User.find_by_id(user_id)
      mail :to => @user.email, :subject => 'Weekly report'
    end
  end

  class Preview < MailView

    def weekly_report
      mail = AdminMailer.weekly_report(User.first.id)
      mail
    end
  end
end
