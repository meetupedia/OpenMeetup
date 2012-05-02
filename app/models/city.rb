# -*- encoding : utf-8 -*-

class City < ActiveRecord::Base
  key :name
  key :permalink

  auto_permalink :name
end

City.auto_upgrade!
