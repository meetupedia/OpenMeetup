# encoding: UTF-8

class City < ActiveRecord::Base
  key :name
  key :permalink
  key :state
  belongs_to :country
  has_many :users, :dependent => :nullify

  auto_permalink :name

  def display_name
    array = if country.andand.name =~ /United States/
      [name, state, country.andand.name]
    else
      [name, country.andand.name]
    end
    array.compact.join(', ')
  end
end

City.auto_upgrade!
