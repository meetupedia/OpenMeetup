# encoding: UTF-8

class Tag < ActiveRecord::Base
  key :name
  key :permalink
  timestamps

  belongs_to :user
  has_many :group_taggings
  has_many :taggings
  has_many :groups, :through => :group_taggings
  has_many :users, :through => :taggings

  auto_permalink :name

  before_validation do |tag|
    tag.name = tag.name.mb_chars.downcase
    true
  end

  def group_tagging_for(group)
    GroupTagging.find_by_tag_id_and_group_id(self.id, group.id)
  end

  def tagging_for(user)
    Tagging.find_by_tag_id_and_user_id(self.id, user.id)
  end
end

Tag.auto_upgrade!
