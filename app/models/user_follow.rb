# encoding: UTF-8

class UserFollow < ActiveRecord::Base
  timestamps

  belongs_to :followed_user, class_name: 'User'
  belongs_to :user
end

UserFollow.auto_upgrade!
