class Authentication < ActiveRecord::Base
  key :uid
  key :provider
  key :settings, as: :binary
  store :settings, accessors: [:facebook_friend_ids, :facebook_access_token]

  belongs_to :user

  validates_uniqueness_of :uid, scope: :provider

  after_create :set_user_facebook_id
  after_destroy :set_user_facebook_id

  def set_user_facebook_id
    if provider == 'facebook'
      user.update_attributes facebook_id: self.uid
    end
  end
end

Authentication.auto_upgrade!
