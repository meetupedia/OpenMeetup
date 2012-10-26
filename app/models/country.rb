# encoding: UTF-8

class Country < ActiveRecord::Base
  key :name, :index => true
  key :permalink, :index => true
  key :code, :index => true
  has_many :cities

  auto_permalink :name

  validates :code, :uniqueness => true
end

Country.auto_upgrade!
