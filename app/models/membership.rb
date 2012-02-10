class Membership < ActiveRecord::Base
  key :is_admin, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :group

  has_many :activities, :as => :activable, :dependent => :destroy
end

Membership.auto_upgrade!
