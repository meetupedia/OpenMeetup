# encoding: UTF-8

class User < ActiveRecord::Base
  key :name
  key :first_name
  key :last_name
  key :nickname
  key :locale
  key :email, index: true
  key :email_confirmed, as: :boolean, default: false
  key :email_bounced, as: :boolean, default: false
  key :crypted_password
  key :password_salt
  key :persistence_token
  key :perishable_token
  key :single_access_token
  key :location
  key :is_admin, as: :boolean, default: false
  key :restricted_access, as: :boolean, default: false
  key :invitation_code
  key :karma, as: :integer, default: 0
  key :last_notified, as: :datetime
  key :avatar_file_name
  key :avatar_content_type
  key :avatar_file_size, as: :integer
  key :avatar_updated_at, as: :datetime
  key :header_file_name
  key :header_content_type
  key :header_file_size, as: :integer
  key :header_updated_at, as: :datetime
  key :facebook_id
  key :enable_weekly_newsletter, as: :boolean, default: true, index: true
  timestamps
  key :memberships_count, as: :integer, default: 0
  key :notifications_count, as: :integer, default: 0

  belongs_to :city
  has_many :absences, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :admined_groups, through: :memberships, source: :group, conditions: {'memberships.is_admin' => true}
  has_many :authentications, dependent: :destroy
  has_many :comments, dependent: :nullify
  has_many :event_invitations, dependent: :nullify
  has_many :events, dependent: :nullify
  has_many :group_invitations, dependent: :nullify
  has_many :groups, dependent: :nullify
  has_many :joined_events, through: :participations, source: :event
  has_many :joined_next_events, through: :participations, source: :event, conditions: ['start_time > ?', Time.now], order: 'start_time ASC'
  has_many :joined_groups, through: :memberships, source: :group
  has_many :memberships, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :uninterests, dependent: :destroy
  has_many :uninterested_events, through: :uninterests, source: :uninterestable, source_type: 'Event'
  has_many :uninterested_groups, through: :uninterests, source: :uninterestable, source_type: 'Group'
  has_many :votes, dependent: :destroy
  has_many :wave_memberships, dependent: :destroy
  has_many :waves, through: :wave_memberships

  has_many :friendships
  has_many :friends, through: :friendships, conditions: {'friendships.is_confirmed' => true}
  has_many :requested_friends, through: :friendships, source: :friend, conditions: {'friendships.is_confirmed' => false}
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user, conditions: {'friendships.is_confirmed' => true}
  has_many :inverse_requested_friends, through: :inverse_friendships, source: :user, conditions: {'friendships.is_confirmed' => false}

  has_attached_file :avatar,
    path: ':rails_root/public/system/:class/:attachment/:style/:class_:id.:extension',
    url: '/system/:class/:attachment/:style/:class_:id.:extension',
    default_url: '/system/:class/missing_:style.png',
    styles: {
      normal: ['270x270#', :jpg],
      small: ['32x32#', :jpg]
    },
    convert_options: {all: '-quality 95 -strip'}

  has_attached_file :header,
    path: ':rails_root/public/system/:class/:attachment/:style/:class_:id.:extension',
    url: '/system/:class/:attachment/:style/:class_:id.:extension',
    default_url: '/system/:class/missing_:style.png',
    styles: {
      normal: ['940x200#', :jpg]
    },
    convert_options: {all: '-quality 95 -strip'}

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.validate_password_field = false
    c.perishable_token_valid_for = 1.day
    c.disable_perishable_token_maintenance = true
  end

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: {if: :crypted_password_changed?}
  validates :password, confirmation: {if: :crypted_password_changed?}
  validates :password_confirmation, presence: {if: :crypted_password_changed?}
  attr_protected :is_admin
  attr_reader :tag_tokens

  before_validation :set_email

  after_create do |user|
    user.update_attributes last_notified: user.created_at
    true
  end

  def set_email
    if Settings.only_for_domain.present?
      self.email = self.email.gsub(/@.*/, '') + '@' + Settings.only_for_domain
    end
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
    authentications.where(provider: provider).first
  end

  def facebook
    @facebook ||= FbGraph::User.new(facebook_id, access_token: authentication_with(:facebook).andand.facebook_access_token).fetch
  end

  def twitter_id
    @twitter_id ||= authentication_with(:twitter).andand.uid
  end

  def friendship_for(user)
    Friendship.find_by_friend_id_and_user_id(user.id, id)
  end

  def add_friend(user)
    Friendship.create friend_id: user.id, user_id: id unless friendship_for(user)
  end

  def remove_friend(user)
    friendship_for(user).andand.destroy
  end

  def facebook_friend_ids
    if authentication = authentication_with(:facebook)
      authentication.facebook_friend_ids
    else
      []
    end
  end

  def connect_facebook_friends
    Authentication.where(provider: 'facebook', uid: facebook_friend_ids).includes(:user).map(&:user).each do |user|
      follow(user)
      user.follow(self)
    end
  end

  def set_karma
    karma = user_follows.count * 5 +
      memberships.count * 10 +
      memberships(is_admin: true) * 40
    update_column :karma, karma
  end

  def get_joined_events_in_next_week(limit = 3)
    Event.joins(:participations).where('participations.user_id' => id).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.week.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def get_events_with_friends_in_next_week(limit = 3)
    Event.joins(:participations).where('participations.user_id' => friend_ids).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.week.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def get_joined_events_in_next_month(limit = 3)
    Event.joins(:participations).where('participations.user_id' => id).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.month.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def get_events_with_friends_in_next_month(limit = 3)
    Event.joins(:participations).where('participations.user_id' => friend_ids).where('events.start_time > ? AND events.end_time < ?', Time.now, 1.month.from_now).order('start_time ASC').group('events.id').limit(limit)
  end

  def friends_in_event(event)
    event.participants.where('users.id' => friend_ids)
  end

  def friends_in_group(group)
    group.members.where('users.id' => friend_ids)
  end

  def recommended_users_hash(limit = 5)
    User.joins(:user_follows).where('friendships.friend_id IN (?) AND users.id NOT IN (?)', friend_ids, friend_ids + [id]).order('count_all DESC').group('users.id').count
  end

  def recommended_groups_hash(limit = 5)
    Group.joins(:memberships).where('memberships.user_id IN (?) AND groups.id NOT IN (?)', friend_ids, joined_group_ids).order('count_all DESC').group('groups.id').count
  end

  def related_groups_through_memberships
    user_ids = User.joins(:memberships).where('memberships.group_id' => self.joined_group_ids).group('users.id').pluck('users.id') - [self.id]
    Group.joins(:memberships).where('memberships.user_id' => user_ids).select('groups.*, COUNT(groups.id) AS count').order('count DESC').group("groups.id HAVING groups.id NOT IN (#{self.joined_groups.to_s(:db)})").limit(10)
  end

  def related_tags_through_taggings
    user_ids = User.joins(:taggings).where('taggings.tag_id' => self.tag_ids).group('users.id').pluck('users.id') - [self.id]
    Tag.joins(:taggings).where('taggings.user_id' => user_ids).select('tags.*, COUNT(tags.id) AS count').order('count DESC').group("tags.id HAVING tags.id NOT IN (#{self.tags.to_s(:db)})").limit(10)
  end

  def related_events_on_next_week
    events = Event.where('start_time > ? AND start_time < ?', Time.now.next_week, Time.now.next_week + 1.week).order('participations_count DESC').limit(10)
    events = events.where("id NOT IN (#{self.joined_next_events.to_s(:db)})") if self.joined_next_events.present?
    events
  end

  def related_images_from_last_week
    images = Image.where('created_at > ?', Time.now.next_week - 1.week).order('votes_count DESC').limit(10)
  end

  def tag_tokens=(names)
    names.split(/,\s*/).each do |name|
      tag = Tag.find_or_create_by_name(name)
      unless tag.tagging_for(self)
        tagging = Tagging.create tag: tag, user: self
        Activity.create_from(tagging, self)
      end
    end
  end

  if Settings.customization == 'get2gather'
    key :read_manual, as: :boolean
    key :read_cobe, as: :boolean

    validates :read_manual, :read_cobe, presence: true
  end
end

User.auto_upgrade!
