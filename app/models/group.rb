class Group < ActiveRecord::Base
  key :user, :as => :references, :index => true
  key :name
  key :description, :as => :text
  key :location
  timestamps
end

Group.auto_upgrade!
