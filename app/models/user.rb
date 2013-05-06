# encoding: UTF-8

class User < ActiveRecord::Base
  key :name
  key :first_name
  key :last_name
  key :nickname
  key :locale
  key :email, :index => true
  key :email_confirmed, :as => :boolean, :default => false
  key :email_bounced, :as => :boolean, :default => false
  key :crypted_password
  key :password_salt
  key :persistence_token
  key :perishable_token
  key :single_access_token
  key :location
  key :is_admin, :as => :boolean, :default => false
  key :restricted_access, :as => :boolean, :default => false
  key :invitation_code
  key :karma, :as => :integer, :default => 0
  key :last_notified, :as => :datetime
  key :avatar_file_name
  key :avatar_content_type
  key :avatar_file_size, :as => :integer
  key :avatar_updated_at, :as => :datetime
  key :header_file_name
  key :header_content_type
  key :header_file_size, :as => :integer
  key :header_updated_at, :as => :datetime
  timestamps
  key :memberships_count, :as => :integer, :default => 0
  key :notifications_count, :as => :integer, :default => 0

  belongs_to :city
  has_many :absences, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :admined_groups, :through => :memberships, :source => :group, :conditions => {'memberships.is_admin' => true}
  has_many :authentications, :dependent => :destroy
  has_many :comments, :dependent => :nullify
  has_many :event_invitations, :dependent => :nullify
  has_many :events, :dependent => :nullify
  has_many :followers, :through => :user_follows, :source => :user
  has_many :group_invitations, :dependent => :nullify
  has_many :groups, :dependent => :nullify
  has_many :joined_events, :through => :participations, :source => :event
  has_many :joined_next_events, :through => :participations, :source => :event, :conditions => ['start_time > ?', Time.now], :order => 'start_time ASC'
  has_many :joined_groups, :through => :memberships, :source => :group
  has_many :memberships, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :participations, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  has_many :user_follows, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :wave_memberships, :dependent => :destroy
  has_many :waves, :through => :wave_memberships

  has_attached_file :avatar,
    :path => ':rails_root/public/system/:class/:attachment/:style/:class_:id.:extension',
    :url => '/system/:class/:attachment/:style/:class_:id.:extension',
    :default_url => '/system/:class/missing_:style.png',
    :styles => {
      :normal => ['270x270#', :jpg],
      :small => ['32x32#', :jpg]
    },
    :convert_options => {:all => '-quality 95 -strip'}

  has_attached_file :header,
    :path => ':rails_root/public/system/:class/:attachment/:style/:class_:id.:extension',
    :url => '/system/:class/:attachment/:style/:class_:id.:extension',
    :default_url => '/system/:class/missing_:style.png',
    :styles => {
      :normal => ['940x200#', :jpg]
    },
    :convert_options => {:all => '-quality 95 -strip'}

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.validate_password_field = false
    c.perishable_token_valid_for = 1.day
    c.disable_perishable_token_maintenance = true
  end

  validates :email, :presence => {:if => :password_required?}, :uniqueness => true
  validates :password, :presence => {:if => :password_required?}, :confirmation => true
  attr_protected :is_admin

  after_create do |user|
    user.update_attributes :last_notified => user.created_at
    true
  end

  def name
    if first_name.present? and last_name.present?
      if locale == 'hu'
        "#{last_name} #{first_name}"
      else
        "#{first_name} #{last_name}"
      end
    else
      attributes['name']
    end
  end

  def password_required?
    authentications.blank? and crypted_password.blank? and not restricted_access
  end

  def admin?
    is_admin?
  end

  def guest?
    false
  end

  def mugshot
    false
  end

  def link
    false
  end

  def deliver_password_reset
    reset_perishable_token!
    UserMailer.password_reset(self).deliver
  end

  def authentication_with(provider)
    authentications.where(:provider => provider).first
  end

  def facebook
    @facebook ||= FbGraph::User.new(facebook_id, :access_token => authentication_with(:facebook).andand.facebook_access_token).fetch
  end

  def facebook_id
    @facebook_id ||= authentication_with(:facebook).andand.uid
  end

  def twitter_id
    @twitter_id ||= authentication_with(:twitter).andand.uid
  end

  def user_follow_for(user)
    UserFollow.find_by_followed_user_id_and_user_id(self.id, user.id)
  end

  def follow(user)
    UserFollow.create :followed_user_id => self.id, :user_id => user.id unless user_follow_for(user)
  end

  def unfollow(user)
    user_follow_for(user).andand.destroy
  end

  def followed_users
    User.joins('INNER JOIN user_follows ON user_follows.followed_user_id = users.id').where('user_follows.user_id' => 1)
  end

  def followed_user_ids
    followed_users.pluck(:id)
  end

  def facebook_friend_ids
    if authentication = authentication_with(:facebook)
      authentication.facebook_friend_ids
    else
      []
    end
  end

  def connect_facebook_friends
    Authentication.where(:provider => 'facebook', :uid => facebook_friend_ids).includes(:user).map(&:user).each do |user|
      follow(user)
      user.follow(self)
    end
  end

  def set_karma
    karma = user_follows.count * 5 +
      memberships.count * 10 +
      memberships(:is_admin => true) * 40
    update_column :karma, karma
  end

  def get_joined_events_in_next_week(limit = 3)
    Event.joins(:participations).where('participations.user_id' => self.id).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.week.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def get_events_with_friends_in_next_week(limit = 3)
    Event.joins(:participations).where('participations.user_id' => followed_user_ids).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.week.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def get_joined_events_in_next_month(limit = 3)
    Event.joins(:participations).where('participations.user_id' => self.id).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.month.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def get_events_with_friends_in_next_month(limit = 3)
    Event.joins(:participations).where('participations.user_id' => followed_user_ids).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.month.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def friends_in_event(event)
    event.participants.where('users.id' => followed_user_ids)
  end

  def friends_in_group(group)
    group.members.where('users.id' => followed_user_ids)
  end

  def recommended_users_hash(limit = 5)
    User.joins(:user_follows).where('user_follows.followed_user_id IN (?) AND users.id NOT IN (?)', self.followed_user_ids, self.followed_user_ids + [self.id]).order('count_all DESC').group('users.id').count
  end

  def recommended_groups_hash(limit = 5)
    Group.joins(:memberships).where('memberships.user_id IN (?) AND groups.id NOT IN (?)', self.followed_user_ids, self.joined_group_ids).order('count_all DESC').group('groups.id').count
  end

  if Settings.customization == 'get2gather'
    key :read_manual, :as => :boolean
    key :read_cobe, :as => :boolean

    validates :read_manual, :read_cobe, :presence => true
  end
end

User.auto_upgrade!
