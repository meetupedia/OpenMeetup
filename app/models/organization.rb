# -*- encoding : utf-8 -*-

class Organization < ActiveRecord::Base
  key :name
  key :permalink
  key :layout_name
  key :layout, :as => :text
  key :stylesheets, :as => :text

  has_many :groups

  auto_permalink :name

  def next_events
    @next_events ||= Event.joins(:group => :organization).where('groups.organization_id' => self.id).where('events.end_time > ?', Time.zone.now).order('events.end_time ASC')
  end

  def tags
    @tags ||= Tag.joins(:group_taggings => {:group => :organization}).where('groups.organization_id' => self.id).order('tags.name ASC')
  end

  def facebook_friends(user)
    @facebook_friends ||= User.joins(:memberships => {:group => :organization}).where('groups.organization_id' => self.id, 'users.uid' => user.facebook_friend_ids).order('users.permalink ASC').group('users.id')
  end
end

Organization.auto_upgrade!
