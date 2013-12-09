# encoding: UTF-8

class Admin

  def self.weekly_newsletter
    User.where(enable_weekly_newsletter: true).where('city_id IS NOT ?', nil).find_each do |user|
      begin
        AdminMailer.weekly_newsletter(user.id).deliver
      rescue
      end
    end
  end

  def self.cron_daily
    Event.find_each { |event| event.set_counters :participations }
    Authentication.find_each { |authentication| authentication.set_user_facebook_id }

    Activity.find_each { |activity| activity.set_counters :comments }
    Event.find_each { |event| event.set_counters :comments }
    Image.find_each { |image| image.set_counters :comments }
    Post.find_each { |post| post.set_counters :comments }

    Tag.remove_duplications
  end

  def self.migration
    UserFollow.find_each do |user_follow|
      Friendship.create user_id: user_follow.user_id, friend_id: user_follow.followed_user_id
    end
  end
end
