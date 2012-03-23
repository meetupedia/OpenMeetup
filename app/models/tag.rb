# -*- encoding : utf-8 -*-

class Tag < ActiveRecord::Base
  key :name
  key :permalink
  timestamps

  belongs_to :user
  has_many :group_taggings
  has_many :taggings

  auto_permalink :name

  def group_tagging_for(group)
    GroupTagging.find_by_tag_id_and_group_id(self.id, group.id)
  end

  def tagging_for(user)
    Tagging.find_by_tag_id_and_user_id(self.id, user.id)
  end
end

Tag.auto_upgrade!
