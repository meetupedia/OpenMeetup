# encoding: UTF-8

class City < ActiveRecord::Base
  key :name, index: true
  key :permalink, index: true
  key :state

  belongs_to :country
  has_many :events, dependent: :nullify
  has_many :groups, dependent: :nullify
  has_many :users, dependent: :nullify

  auto_permalink :name

  def display_name
    if country
      if country.name =~ /United States/
        "#{name} (#{state}, #{country.name})"
      else country
        "#{name} (#{country.name})"
      end
    else
      name
    end
  end

  def self.find_or_create_with_country(arg)
    if arg.is_a?(String)
      city_name, country_name = $1, $3 if arg =~ /([^(]+)( *\(([^)]+)\))*/
      city = if city_name =~ /\A\d+\Z/
        City.find_by_id(city_name)
      else
        City.find_by_permalink(city_name)
      end
    else
      city = City.find_by_id(arg)
    end
    unless city
      unless country_name.blank?
        country = Country.find_by_name(country_name)
        country ||= Country.create name: country_name
      end
      city = City.create name: city_name
      if country
        city.country = country
        city.save
      end
    end
    city
  end
end

City.auto_upgrade!
