# encoding: UTF-8

class Admin

  def weekly_report
    User.where(is_admin: true).each do |user|
      AdminMailer.weekly_report(user.id).deliver
    end
  end
end
