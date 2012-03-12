class Follow < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :group

  has_many :activities, :as => :activable, :dependent => :destroy
end

Follow.auto_upgrade!
