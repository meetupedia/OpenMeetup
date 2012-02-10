class Review < ActiveRecord::Base
  key :text, :as => :text
  timestamps

  belongs_to :user
  belongs_to :event

  has_many :activities, :as => :activable, :dependent => :destroy
end

Review.auto_upgrade!
