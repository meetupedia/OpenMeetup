# -*- encoding : utf-8 -*-

class GroupInvitation < ActiveRecord::Base
  key :message, :as => :text
  timestamps

  belongs_to :user
  belongs_to :group

  attr_accessor :emails
end

GroupInvitation.auto_upgrade!
