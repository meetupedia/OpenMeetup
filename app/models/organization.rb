# -*- encoding : utf-8 -*-

class Organization < ActiveRecord::Base
  key :name
  key :permalink
  key :layout_name
  key :layout, :as => :text
  key :stylesheets, :as => :text

  has_many :groups

  auto_permalink :name
end

Organization.auto_upgrade!
