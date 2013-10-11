class MinionJob < ActiveRecord::Base
  key :action
  key :run_at, as: :datetime
  key :is_processed, as: :boolean, default: false
  key :is_unprocessable, as: :boolean, default: false
  timestamps

  belongs_to :item, polymorphic: true
end

MinionJob.auto_upgrade!
