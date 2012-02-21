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
  has_many :members, :through => :memberships, :source => :user

  after_create :create_admin_membership

  def create_admin_membership
    membership = Membership.create :group => self, :is_admin => true
    Activity.create :activable => membership
  end

  def membership_for(user)
    Membership.find_by_group_id_and_user_id(self.id, user.id)
  end
end

Group.auto_upgrade!
