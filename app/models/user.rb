# -*- encoding : utf-8 -*-

class User < ActiveRecord::Base
  key :provider
  key :uid
  key :name
  key :permalink
  key :email
  key :token
  key :location
  key :is_admin, :as => :boolean
  key :facebook_friend_ids, :as => :text
  timestamps

  belongs_to :city
  has_many :absences, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :admined_groups, :through => :memberships, :source => :group, :conditions => {'memberships.is_admin' => true}
  has_many :event_invitations, :dependent => :nullify
  has_many :event_invitation_targets, :foreign_key => :invited_user_id, :dependent => :destroy
  has_many :events, :dependent => :nullify
  has_many :follows, :dependent => :destroy
  has_many :group_invitations, :dependent => :nullify
  has_many :groups, :dependent => :nullify
  has_many :joined_events, :through => :participations, :source => :event
  has_many :joined_next_events, :through => :participations, :source => :event, :conditions => ['start_time > ?', Time.now], :order => 'start_time ASC'
  has_many :joined_groups, :through => :memberships, :source => :group
  has_many :memberships, :dependent => :destroy
  has_many :participations, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  has_many :user_follows, :dependent => :destroy
  has_many :wave_memberships, :dependent => :destroy
  has_many :waves, :through => :wave_memberships

  serialize :facebook_friend_ids
  auto_permalink :name

  attr_protected :is_admin

  after_validation :set_city

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
    end
  end

  def facebook
    @facebook ||= FbGraph::User.new(self.uid, :access_token => self.token).fetch
  end

  def user_follow_for(user)
    UserFollow.find_by_followed_user_id_and_user_id(self.id, user.id)
  end

  def followed_users
    User.joins('INNER JOIN user_follows ON user_follows.followed_user_id = users.id').where('user_follows.user_id' => 1)
  end

  def set_city
    self.city = City.find_or_create_by_name(self.location || 'Budapest') unless self.location.blank?
  end
end

User.auto_upgrade!
