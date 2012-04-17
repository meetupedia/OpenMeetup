# -*- encoding : utf-8 -*-

class Membership < ActiveRecord::Base
  key :is_admin, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :group

  has_many :activities, :as => :activable, :dependent => :destroy

  attr_protected :is_admin
end

Membership.auto_upgrade!
