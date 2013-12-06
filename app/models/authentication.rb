# encoding: UTF-8

class Authentication < ActiveRecord::Base
  key :uid
  key :provider
  key :settings, as: :binary
  store :settings, accessors: [:facebook_friend_ids, :facebook_access_token]

  belongs_to :user

  validates_uniqueness_of :uid, scope: :provider

  after_create do
    if provider == 'facebook'
      user.update_attributes facebook_id: self.uid
    end
  end

  after_destroy do
    if provider == 'facebook'
      user.update_attributes facebook_id: nil
    end
  end
end

Authentication.auto_upgrade!
