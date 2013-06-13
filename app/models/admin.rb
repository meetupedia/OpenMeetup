# encoding: UTF-8

class Admin

  def weekly_report
    User.where(is_admin: true).each do |user|
      AdminMailer.weekly_report(user.id).deliver
    end
  end

  def cron_daily
    Event.find_each { |event| event.set_counters :participations }
  end
end
