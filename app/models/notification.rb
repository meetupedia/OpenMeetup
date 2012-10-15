# encoding: UTF-8

class Notification < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :group
  belongs_to :activity
end

Notification.auto_upgrade!
