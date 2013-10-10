# encoding: UTF-8

class MinionJob < ActiveRecord::Base
  key :action
  key :run_at, as: :datetime
  key :is_mailed, as: :boolean, default: false
  timestamps

  belongs_to :user
  belongs_to :item, polymorphic: true
end

MinionJob.auto_upgrade!
