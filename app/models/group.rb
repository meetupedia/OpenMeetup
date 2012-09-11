# encoding: UTF-8

class Group < ActiveRecord::Base
  key :name
  key :facebook_uid
  key :permalink, :index => true
  key :description, :as => :text
  key :location, :index => true
  key :image_file_name
  key :image_content_type
  key :image_file_size, :as => :integer
  key :image_updated_at, :as => :datetime
  key :header_file_name
  key :header_content_type
  key :header_file_size, :as => :integer
  key :header_updated_at, :as => :datetime
  key :is_closed, :as => :boolean, :default => false
  key :url
  key :facebook_url
  timestamps

  belongs_to :city
  belongs_to :language
  belongs_to :user
  has_many :activities, :dependent => :destroy
  has_many :admins, :through => :memberships, :source => :user, :conditions => {'memberships.is_admin' => true}
  has_many :events, :dependent => :destroy
  has_many :group_invitations, :dependent => :nullify
  has_many :group_taggings, :dependent => :destroy
  has_many :images, :as => :imageable
  has_many :membership_requests, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_many :posts, :as => :postable, :dependent => :destroy
  has_many :requested_members, :through => :membership_requests, :source => :user
  has_many :reviews, :dependent => :destroy
  has_many :tags, :through => :group_taggings
  has_many :waves, :dependent => :nullify

  attr_reader :tag_tokens

  has_attached_file :header,
    :path => ':rails_root/public/system/:class/:attachment/:style/:class_:id.:extension',
    :url => '/system/:class/:attachment/:style/:class_:id.:extension',
    :default_url => '/assets/:class_missing_:style.png',
    :styles => {
      :normal => ['960>', :jpg]
    },
    :convert_options => {:all => '-quality 95 -strip'}

  has_attached_file :image,
    :path => ':rails_root/public/system/:class/:style/:class_:id.:extension',
    :url => '/system/:class/:style/:class_:id.:extension',
    :default_url => '/assets/:class_missing_:style.png',
    :styles => {
      :normal => ['500x500>', :jpg],
      :small => ['72x72#', :jpg]
    },
    :convert_options => {:all => '-quality 95 -strip'}

  auto_permalink :name

  after_create :create_admin_membership, :write_language
  after_validation :set_city

  def add_tag_by_name(name)
    if tag = Tag.find_by_name(name)
      GroupTagging.find_or_create_by_group_id_and_tag_id(self.id, tag.id)
    end
  end

  def create_admin_membership
    membership = Membership.create :group => self
    membership.is_admin = true
    membership.save
  end

  def follow_for(user)
    Follow.find_by_group_id_and_user_id(self.id, user.id)
  end

  def group_tagging_for(tag)
    GroupTagging.find_by_group_id_and_tag_id(self.id, tag.id)
  end

  def membership_for(user)
    Membership.find_by_group_id_and_user_id(self.id, user.id)
  end

  def membership_request_for(user)
    MembershipRequest.find_by_group_id_and_user_id(self.id, user.id)
  end

  def next_event
    @next_event ||= events.where('start_time > ?', Time.zone.now).order('start_time ASC').first
  end

  def review_for(user)
    Review.find_by_group_id_and_user_id(self.id, user.id)
  end

  def set_city
    self.city = City.find_or_create_by_name(self.location)
  end

  def tag_tokens=(names)
    ids = []
    names.split(/,\s*/).each do |name|
      ids << Tag.find_or_create_by_name(name).id
    end
    self.tag_ids = ids
  end

  def write_language(code = nil)
    code ||= I18n.locale
    self.language = Language.find_or_create_by_code(code)
    save
  end

  def self.tagged_groups_for(user)
    self.joins(:tags, :language, :city).where('cities.id' => user.city_id, 'languages.code' => I18n.locale, 'tags.id' => user.tags, 'groups.is_closed' => false).select('groups.*, COUNT(group_taggings.tag_id) AS count').group('groups.id').order('count DESC')
  end

  def self.per_page
    20
  end

  def self.recommended_groups_for(user, limit = 10)
    tagged_groups = self.tagged_groups_for(user).limit(limit)
    new_groups = self.joins(:language, :city).where('cities.id' => user.city_id, 'languages.code' => I18n.locale, :is_closed => false).order('created_at DESC').limit(limit)
    (tagged_groups + (new_groups - tagged_groups))[0...limit]
  end
end

Group.auto_upgrade!
