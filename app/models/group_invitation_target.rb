# -*- encoding : utf-8 -*-

class GroupInvitationTarget < ActiveRecord::Base
  key :email
  key :is_accepted, :as => :boolean
  timestamps

  belongs_to :group
  belongs_to :group_invitation
end

GroupInvitationTarget.auto_upgrade!
