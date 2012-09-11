# encoding: UTF-8

class Activity < ActiveRecord::Base
  timestamps

  belongs_to :activable, :polymorphic => true
  belongs_to :group
  belongs_to :user
end

Activity.auto_upgrade!
