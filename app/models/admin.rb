# encoding: UTF-8

class Admin

  def self.weekly_report
    User.where(is_admin: true).each do |user|
      AdminMailer.weekly_report(user.id).deliver
    end
  end

  def self.cron_daily
    Event.find_each { |event| event.set_counters :participations }
    Authentication.find_each { |authentication| authentication.set_user_facebook_id }

    Activity.find_each { |activity| activity.set_counters :comments }
    Event.find_each { |event| event.set_counters :comments }
    Image.find_each { |image| image.set_counters :comments }
    Post.find_each { |post| post.set_counters :comments }
  end
end
