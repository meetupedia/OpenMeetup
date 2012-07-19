# encoding: UTF-8

class InterestTagging < ActiveRecord::Base
  timestamps

  belongs_to :interest
  belongs_to :user
end

GroupTagging.auto_upgrade!
