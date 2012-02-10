class User < ActiveRecord::Base
  key :provider
  key :uid
  key :name
  timestamps

  has_many :activities, :dependent => :destroy
  has_many :event_invitations, :dependent => :nullify
  has_many :events, :dependent => :nullify
  has_many :follows, :dependent => :destroy
  has_many :group_invitations, :dependent => :nullify
  has_many :groups, :dependent => :nullify
  has_many :memberships, :dependent => :destroy
  has_many :participations, :dependent => :destroy
  has_many :reviews, :dependent => :destroy

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
    end
  end
end

User.auto_upgrade!
