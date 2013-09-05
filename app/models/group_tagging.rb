# encoding: UTF-8

class GroupTagging < ActiveRecord::Base
  timestamps

  belongs_to :group
  belongs_to :tag
  belongs_to :user
end

GroupTagging.auto_upgrade!
