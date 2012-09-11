# encoding: UTF-8

class MembershipRequest < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :group
end

MembershipRequest.auto_upgrade!
