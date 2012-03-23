# -*- encoding : utf-8 -*-

class User < ActiveRecord::Base
  key :provider
  key :uid
  key :name
  key :permalink
  key :token
  key :location
  key :is_admin, :as => :boolean
  timestamps

  has_many :activities, :dependent => :destroy
  has_many :admined_groups, :through => :memberships, :source => :group, :conditions => {'memberships.is_admin' => true}
  has_many :event_invitations, :dependent => :nullify
  has_many :events, :dependent => :nullify
  has_many :follows, :dependent => :destroy
  has_many :group_invitations, :dependent => :nullify
  has_many :groups, :dependent => :nullify
  has_many :joined_events, :through => :participations, :source => :event
  has_many :joined_next_events, :through => :participations, :source => :event, :conditions => ['start_time > ?', Time.now], :order => 'start_time ASC'
  has_many :joined_groups, :through => :memberships, :source => :group
  has_many :memberships, :dependent => :destroy
  has_many :participations, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  auto_permalink :name

  attr_protected :is_admin

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
    end
  end

  def facebook
    @facebook ||= FbGraph::User.new(self.uid, :access_token => self.token).fetch
  end
end

User.auto_upgrade!
