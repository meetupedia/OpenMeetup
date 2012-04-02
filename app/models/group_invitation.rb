# -*- encoding : utf-8 -*-

class GroupInvitation < ActiveRecord::Base
  key :emails, :as => :text
  key :message, :as => :text
  timestamps

  belongs_to :user
  belongs_to :group
end

GroupInvitation.auto_upgrade!
