class Authentication < ActiveRecord::Base
  key :uid
  key :provider

  belongs_to :user

  validates_uniqueness_of :uid, :scope => :provider
end

Authentication.auto_upgrade!
