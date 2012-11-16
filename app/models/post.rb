# encoding: UTF-8

class Post < ActiveRecord::Base
  include CommonCommentable
  key :post, :as => :text
  key :is_highlighted, :as => :boolean, :default => false
  key :is_broadcasted, :as => :boolean, :default => false
  key :is_live, :as => :boolean, :default => false
  timestamps

  belongs_to :user
  belongs_to :postable, :polymorphic => true

  validates_presence_of :post
end

Post.auto_upgrade!
