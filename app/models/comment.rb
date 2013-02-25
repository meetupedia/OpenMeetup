# encoding: UTF-8

class Comment < ActiveRecord::Base
  key :comment, :as => :text
  key :is_highlighted, :as => :boolean, :default => false
  key :level, :as => :integer, :default => 0
  timestamps

  belongs_to :user
  belongs_to :commentable, :polymorphic => true, :counter_cache => true, :touch => true
  belongs_to :reply_to, :class_name => 'Comment'
  has_many :replies, :class_name => 'Comment', :foreign_key => 'reply_to_id'

  validates_presence_of :comment

  after_validation do |comment|
    comment.level = comment.reply_to.level + 1 if comment.reply_to
  end

  def root_comment
    output = self
    output = output.reply_to while output.reply_to
    output
  end
end

Comment.auto_upgrade!
