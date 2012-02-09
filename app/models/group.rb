class Group < ActiveRecord::Base
  key :name
  key :description, :as => :text
  key :location
  timestamps

  belongs_to :user
  has_many :activities, :as => :activable, :dependent => :destroy
end

Group.auto_upgrade!
