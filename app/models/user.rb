class User < ActiveRecord::Base
  key :provider
  key :uid
  key :name
  timestamps

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
    end
  end
end

User.auto_upgrade!
