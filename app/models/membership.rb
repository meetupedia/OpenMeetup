# -*- encoding : utf-8 -*-
class Membership < ActiveRecord::Base
  key :is_admin, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :group

  has_many :activities, :as => :activable, :dependent => :destroy

  after_create :create_auto_follow

  def create_auto_follow
    Follow.create :group => group
  end
end

Membership.auto_upgrade!
