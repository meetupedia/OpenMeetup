# encoding: UTF-8

class Comment < ActiveRecord::Base
  key :comment, :as => :text
  key :is_highlighted, :as => :boolean, :default => false
  timestamps

  belongs_to :user
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :reply_to, :class_name => 'Comment'
  has_many :replies, :class_name => 'Comment', :foreign_key => 'reply_to_id'

  validates_presence_of :comment
end

Comment.auto_upgrade!
