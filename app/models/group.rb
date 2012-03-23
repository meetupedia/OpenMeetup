# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base
  key :name
  key :permalink, :index => true
  key :description, :as => :text
  key :location, :index => true
  key :image_file_name
  key :image_content_type
  key :image_file_size, :as => :integer
  key :image_updated_at, :as => :datetime
  timestamps

  belongs_to :user
  has_many :activities, :as => :activable, :dependent => :destroy
  has_many :admins, :through => :memberships, :source => :user, :conditions => {'memberships.is_admin' => true}
  has_many :events, :dependent => :destroy
  has_many :follows, :dependent => :destroy
  has_many :followers, :through => :follows, :source => :user
  has_many :group_invitations, :dependent => :nullify
  has_many :group_taggings, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_many :reviews, :dependent => :destroy
  has_many :tags, :through => :group_taggings

  has_attached_file :image,
    :path => ':rails_root/public/system/:class/:style/:class_:id.:extension',
    :url => '/system/:class/:style/:class_:id.:extension',
    :default_url => '/system/:class/missing_:style.png',
    :styles => {
      :normal => ['500x500>', :jpg],
      :small => ['100x100>', :jpg]
    },
    :convert_options => {:all => '-quality 95 -strip'}

  auto_permalink :name

  after_create :create_admin_membership

  def add_tag_by_name(name)
    if tag = Tag.find_by_name(name)
      GroupTagging.find_or_create_by_group_id_and_tag_id(self.id, tag.id)
    end
  end

  def create_admin_membership
    Membership.create :group => self, :is_admin => true
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

  def review_for(user)
    Review.find_by_group_id_and_user_id(self.id, user.id)
  end

  def self.tagged_groups_for(user)
    self.joins(:tags).where('tags.id' => user.tags).select('groups.*, COUNT(group_taggings.tag_id) AS count').group('groups.id').order('count DESC')
  end

  def self.recommended_groups_for(user, limit = 10)
    tagged_groups = self.tagged_groups_for(user).limit(limit)
    new_groups = self.order('created_at DESC').limit(limit)
    (tagged_groups + (new_groups - tagged_groups))[0...limit]
  end
end

Group.auto_upgrade!
