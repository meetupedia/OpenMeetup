class Group < ActiveRecord::Base
  key :name
  key :description, :as => :text
  key :location
  timestamps

  belongs_to :user
  has_many :activities, :as => :activable, :dependent => :destroy
  has_many :admins, :through => :memberships, :source => :user, :conditions => {'memberships.is_admin' => true}
  has_many :events, :dependent => :destroy
  has_many :group_invitations, :dependent => :nullify
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :class_name => 'User'
end

Group.auto_upgrade!
