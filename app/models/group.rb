# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base
  key :name
  key :permalink, :index => true
  key :description, :as => :text
  key :location, :index => true
  timestamps

  belongs_to :user
  has_many :activities, :as => :activable, :dependent => :destroy
  has_many :admins, :through => :memberships, :source => :user, :conditions => {'memberships.is_admin' => true}
  has_many :events, :dependent => :destroy
  has_many :follows, :dependent => :destroy
  has_many :followers, :through => :follows, :source => :user
  has_many :group_invitations, :dependent => :nullify
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_many :reviews, :dependent => :destroy

  auto_permalink :name

  after_create :create_admin_membership

  def create_admin_membership
    Membership.create :group => self, :is_admin => true
  end

  def follow_for(user)
    Follow.find_by_group_id_and_user_id(self.id, user.id)
  end

  def membership_for(user)
    Membership.find_by_group_id_and_user_id(self.id, user.id)
  end

  def review_for(user)
    Review.find_by_group_id_and_user_id(self.id, user.id)
  end
end

Group.auto_upgrade!
