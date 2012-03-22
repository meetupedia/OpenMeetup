# -*- encoding : utf-8 -*-
class GroupInvitation < ActiveRecord::Base
  key :is_accepted, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :group
end

GroupInvitation.auto_upgrade!
