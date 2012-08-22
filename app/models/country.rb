# encoding: UTF-8

class Country < ActiveRecord::Base
  key :name
  key :permalink
  key :code
  has_many :cities

  auto_permalink :name
end

Country.auto_upgrade!
