# encoding: UTF-8

class InvitedInterestTagging < ActiveRecord::Base
  timestamps

  belongs_to :interest
  belongs_to :invited_user
end

InvitedInterestTagging.auto_upgrade!
