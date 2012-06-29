# -*- encoding : utf-8 -*-

class GroupInvitationTarget < ActiveRecord::Base
  key :email
  key :is_accepted, :as => :boolean
  timestamps

  belongs_to :group
  belongs_to :group_invitation
  belongs_to :invited_user, :class_name => 'User'
end

GroupInvitationTarget.auto_upgrade!
