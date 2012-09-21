# encoding: UTF-8

class Activity < ActiveRecord::Base
  timestamps

  belongs_to :activable, :polymorphic => true
  belongs_to :group
  belongs_to :user

  def self.per_page
    20
  end
end

Activity.auto_upgrade!
