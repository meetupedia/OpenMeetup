class Authentication < ActiveRecord::Base
  key :uid
  key :provider
  key :settings, :as => :binary
  store :settings, :accessors => [:facebook_friend_ids, :facebook_access_token]

  belongs_to :user

  validates_uniqueness_of :uid, :scope => :provider
end

Authentication.auto_upgrade!
