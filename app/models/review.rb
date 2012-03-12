class Review < ActiveRecord::Base
  key :review, :as => :text
  key :recommendation, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :group

  has_many :activities, :as => :activable, :dependent => :destroy
end

Review.auto_upgrade!
