# encoding: UTF-8

class Tag < ActiveRecord::Base
  key :name
  key :permalink
  timestamps

  belongs_to :language
  belongs_to :user
  has_many :group_taggings
  has_many :taggings
  has_many :groups, :through => :group_taggings
  has_many :users, :through => :taggings

  auto_permalink :name

  after_create :write_language

  def group_tagging_for(group)
    GroupTagging.find_by_tag_id_and_group_id(self.id, group.id)
  end

  def write_language(code = nil)
    code ||= I18n.locale
    self.language = Language.find_or_create_by_code(code)
    save
  end

  def tagging_for(user)
    Tagging.find_by_tag_id_and_user_id(self.id, user.id)
  end
end

Tag.auto_upgrade!
